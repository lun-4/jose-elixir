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
  end

  def start(_type, _args) do
    run = Client.start(Application.fetch_env!(:jose, :token))
    Alchemy.Cogs.set_prefix(Application.fetch_env!(:jose, :prefix))
    use BaseCommands
    use JoseEval
    use JoseAdmin
    run
  end
end
