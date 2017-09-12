defmodule Booru do
  def fetch(url, tags) do
    fetch(url, tags, 5)
  end

  def fetch(url, tags, limit) do
    encoded = URI.encode(tags)
    response = HTTPoison.get!("#{url}?limit=#{limit}&tags=#{encoded}")
    postdata = Poison.decode! response.body
    postdata
  end
end

defmodule Nsfw do
  alias Alchemy.Cache
  alias Alchemy.Client
  alias Alchemy.Embed

  def fetch_e621(tags) do
    fetch_e621(tags, 5)
  end

  def fetch_e621(tags, limit) do
    Booru.fetch("https://e621.net/post/index.json", tags, limit)
  end

  def e621_format(post_id) do
    "https://e621.net/post/show/#{post_id}"
  end

  def make_embed(post) do
    %Embed{}
    |> Embed.title("Posted by #{post["author"]}")
    |> Embed.field("Tags", post["tags"])
    |> Embed.field("URL", e621_format(post["id"]))
    |> Embed.image(post["file_url"])
  end

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.set_parser :e621, &List.wrap/1
    Cogs.def e621(tags) do
      {:ok, guild_id} = Cogs.guild_id()
      {:ok, channel} = Cache.channel(guild_id, message.channel_id)

      case channel.nsfw do
        true -> 
          posts = Nsfw.fetch_e621(tags)

          case Enum.count(posts) do
            0 -> Cogs.say "nothing found"
            _ ->
              e = Enum.at(posts, 0)
              |> Nsfw.make_embed
              
              Client.send_message(message.channel_id, "", [embed: e])
          end
        _ -> Cogs.say "no nsfw in sfw chan reeee"
      end
    end
  end
end
