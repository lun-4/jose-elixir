defmodule Basic do
  alias Alchemy.Embed
  require Alchemy.Embed

  defmodule Commands do
    use Alchemy.Cogs

    @doc """
    Show help about all commands in José.
    """
    Cogs.def help do
      e = %Alchemy.Embed{description: ""}
      |> Embed.title("Command list")

      all = Alchemy.Cogs.all_commands
      
      reduced = all
      |> Map.keys
      |> Enum.map_reduce(e, fn (key, e) ->
        value = Map.get(all, key)

        module = elem value, 0
        arity = elem value, 1
        name = elem value, 2

        formatted = "#{name}/#{arity}"
        new_embed = Embed.description(e, "#{e.description}\n#{formatted}")
        {formatted, new_embed}
      end)

      help_embed = elem reduced, 1
      Embed.send help_embed

    end

  end
end
