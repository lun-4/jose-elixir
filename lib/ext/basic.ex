defmodule Basic do
  alias Alchemy.Embed
  require Alchemy.Embed

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.def help do
      e = %Alchemy.Embed{description: ""}
      |> Embed.title("Command list")

      all = Alchemy.Cogs.all_commands
      all
      |> Map.keys
      |> Enum.each(fn key ->
        e = Embed.description(e, "#{e.description}\n#{key}")
      end)

      Embed.send e

    end

  end
end
