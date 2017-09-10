defmodule JoseEval do
  alias Alchemy.Client
  use Alchemy.Cogs
  
  Cogs.set_parser(:eval, &List.wrap/1)
  Cogs.def eval(code) do
    if Utils.is_admin?(message) do
      try do
        {result, env} = code
        |> Utils.strip_markup
        |> Code.eval_string([msg: message])

        Client.add_reaction(message, "\u2705")

        env = Keyword.delete(env, :msg)
        Cogs.say "result: ```elixir\n#{inspect result}\n```\nenv: ```\n#{inspect env}```"
      rescue
        e -> Cogs.say "#{inspect e}"
      end
    else
      Cogs.say "nope you can't do this"
    end
  end

end

