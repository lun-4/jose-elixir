defmodule Extra do
  require Alchemy.Embed
  alias Alchemy.Embed

  alias Alchemy.Client
  alias Alchemy.Cache

  def get_profile(guild, userid) do
    case Cache.member(guild, userid) do
      {:ok, member} ->
        {:ok, %{}}
      {:error, err} -> {:error, err}
    end
  end
  
  def make_embed(profile) do
    case profile do
      {:ok, profile} ->
        %Embed{description: "it works"}
      {:error, err} ->
        %Embed{description: "error: #{err}"}
    end
  end

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.def avatar do
      avatar_type = if String.starts_with?(message.author.avatar, "a_") do
        "gif"
      else
        "png"
      end

      case avatar_type do
        "gif" ->
          url = message.author
          |> Alchemy.User.avatar_url(avatar_type, 128)

          len = String.length url

          String.slice(url, 0..(len - 10))
          |> Cogs.say
        _ ->
          message.author
          |> Alchemy.User.avatar_url(avatar_type, 1024)
          |> Cogs.say
      end

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

    Cogs.def profile do
      {:ok, guild} = Cogs.guild_id

      get_profile(guild, message.author.id)
      |> make_embed
      |> Embed.send
    end

    Cogs.set_parser(:profile, &List.wrap/1)
    Cogs.def profile(someone) do
      case Utils.user_id(someone) do
        {:ok, id} ->
          {:ok, guild} = Cogs.guild_id

          get_profile(guild, id)
          |> make_embed
          |> Embed.send

        {:error, err} ->
          Cogs.say "Error parsing user ID: #{err}"
      end
    end

  end
end
