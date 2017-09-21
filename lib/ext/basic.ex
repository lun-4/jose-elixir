defmodule Basic do
  alias Alchemy.Embed
  require Alchemy.Embed

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.def help do
      e = %Alchemy.Embed{description: ""}
      |> Embed.title("Command list")

      all = Alchemy.Cogs.all_commands
      
      reduced = all
      |> Map.keys
      |> Enum.map_reduce(e, fn key ->
        {key, Embed.description(e, "#{e.description}\n#{key}")}
      end)

      help_embed = elem reduced, 1
      Embed.send help_embed

    end

  end
end
