defmodule Issues.CLI do
    alias Issues.GithubIssues 
    def run(argv) do
        argv
        |> parse_args()
        |> process()
    end
    def process(:help) do
        IO.puts """
        usage: issues <user> <project> [count | #{@default_count}]
        """
        System.halt(0)
    end

    def process({user, project, _count}) do
        GithubIssues.fetch(user, project)
        |> decode_response
        |> sort_into_descending_order
        |> last(count)
    end

    def decode_response({:ok, body}), do: body

    def decode_response({:error, error}) do
        IO.puts "Error fetching from github: #{error["messages"]}"
        System.halt(2)
    end

    def sort_into_descending_order(list_of_issues) do
        list_of_issues
        |> Enum.sort( fn l1, l2 ->
            l1["created_at"] >= l2["created_at"] 
        end)
    end

    def last(list, count) do
        list
        |> Enum.take(count)
        |> Enum.reverse

    def parse_args(argv) do
        OptionParser.parse(argv, switches: [ help: :boolean],
        aliases: [ h: :help])
        |> elem(1)
        |> args_to_internal_representation()
    end

    def args_to_internal_representation([user, project, count]) do
        {user, project, String.to_integer(count) }
    end

    def args_to_internal_representation([user, project]) do
        { user, project, @default_count }
    end

    def args_to_internal_representation(_) do # bad arg or --help
        :help
    end
    
end