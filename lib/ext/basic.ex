defmodule Basic do
  alias Alchemy.Embed
  require Alchemy.Embed

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.def help do
      all_commands = Cogs.all_commands

      all_commands
      |> Map.keys()
      |> Enum.each(fn key do
        command_data = Map.get(all_commands, key)

      end)

      e = %Alchemy.Embed{description: ""}
      |> Embed.title("Command list")

      all = Alchemy.Cogs.all_commands
      all
      |> Map.keys
      |> Enum.each(fn key ->
        #data = Map.get(all, key)

        e = e
            |> Embed.description(e.desription ++ "#{key}\n")
      end)

      Embed.send e

    end

  end
end
