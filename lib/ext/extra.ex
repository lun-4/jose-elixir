defmodule Extra do
  require Alchemy.Embed
  alias Alchemy.Embed

  alias Alchemy.Client
  alias Alchemy.Cache

  def get_profile(guild, userid) do
    case Cache.member(guild, userid) do
      {:ok, member} ->
        {:ok, %{member: member}}
      {:error, err} -> {:error, err}
    end
  end

  def get_name(member) do
    uname = member.user.username
    case member.nick do
      nil -> "#{uname}"
      nickname -> "#{nickname} (#{uname})"
    end
  end

  def make_embed(profile) do
    case profile do
      {:ok, profile} ->
        %{member: member} = profile

        footer = %Alchemy.Embed.Footer{text: "User ID: #{member.user.id}",
                                      icon_url: ""
        }

        %Embed{title: "Profile card"}
        |> Embed.footer(footer)
        |> Embed.thumbnail(Utils.user_avatar(member.user))
        |> Embed.field("Name", get_name(member))

      {:error, err} ->
        %Embed{description: "error: #{err}"}
    end
  end

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.def avatar do
      Utils.user_avatar(message.author)
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

    Cogs.def profile do
      {:ok, guild} = Cogs.guild_id

      Extra.get_profile(guild, message.author.id)
      |> Extra.make_embed
      |> Embed.send
    end

    Cogs.def profile(someone) do
      case Utils.user_id(someone) do
        {:ok, id} ->
          {:ok, guild} = Cogs.guild_id

          Extra.get_profile(guild, id)
          |> Extra.make_embed
          |> Embed.send

        {:error, err} ->
          Cogs.say "Error parsing user ID: #{err}"
      end
    end

  end
end
