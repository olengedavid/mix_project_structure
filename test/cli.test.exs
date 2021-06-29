defmodule IssuesTest do
    use ExUnit.Case
    doctest Issues

    import Issues.CLI, only: [parse_args: 1, sort_into_descending_order: 1]

    test ":help returned by option parsing with -h and --help options" do
        assert parse_args(["-h", "anything"]) == :help
        assert parse_args(["--help", "anything"]) == :help
    end
    test "three values returned if three given" do
        assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
    end 

    test "count is default if two values is given" do
        assert parse_args(["user", "project"]) == {"user", "project", 4}
    end

    test "sort into descending order correctly" do
        result = sort_into.descending_order(fake_created_at_list(["c", "d", "e"," a"]))
        issues = for issues <- result , do: Map.get(issues, "created_at")
        assert issues = ~w(a b c d e)
    end
    
    defp fake_created_at_list(values) do
        for value <- values,
         do:    %{"created_at" => value, "other_data" => "xxx"}
    end
end