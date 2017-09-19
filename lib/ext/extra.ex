defmodule Extra do
  require Alchemy.Embed
  alias Alchemy.Embed
  alias Alchemy.Client

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.def avatar do
      avatar_type = if String.starts_with?(message.author.avatar, "a_") do
        "gif"
      else
        "png"
      end

      message.author
      |> Alchemy.User.avatar_url(avatar_type, 1024)
      |> Cogs.say
    end

    Cogs.def awoo do
      Cogs.say "https://cdn.discordapp.com/attachments/202055538773721099/257717450135568394/awooo.gif"
    end

    Cogs.def presence do
      {:ok, id} = Cogs.guild_id()
      case Alchemy.Cache.presence(id, message.author.id) do
        {:ok, presence} ->
          game = presence.game
          Cogs.say game
        {:error, err} -> Cogs.say "error: #{err}"
      end
    end
  end
end
