defmodule Jose do
  use Application
  alias Alchemy.Client

  defmodule BaseCommands do
    use Alchemy.Cogs

    Cogs.def ping do
      time1 = System.monotonic_time()
      {:ok, p} = Cogs.say "."
      time2 = System.monotonic_time()

      sec = System.convert_time_unit(1, :millisecond, :native)
      delta = (time2 - time1) / sec
      deltastr = :erlang.float_to_binary(delta, [{:decimals, 2}])
      Client.edit_message(p, "`#{deltastr}ms`")
    end

    Cogs.def nsfw do
      {:ok, guild_id} = Cogs.guild_id()
      case Alchemy.Cache.channel(guild_id, message.channel_id) do
        {:ok, chan} ->
           Cogs.say "#{inspect chan.nsfw}"
        err -> Cogs.say "#{inspect err}"
      end
    end
  end

  def start(_type, _args) do
    Queue.Registry.start
    run = Client.start(Application.fetch_env!(:jose, :token))
    Alchemy.Cogs.set_prefix(Application.fetch_env!(:jose, :prefix))

    use BaseCommands
    use Basic.Commands

    use JoseEval
    use JoseAdmin
    use Nsfw.Commands
    use Extra.Commands
    use Music.Commands

    run
  end
end
