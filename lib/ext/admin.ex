defmodule JoseAdmin do
  alias Alchemy.Client
  use Alchemy.Cogs

  Cogs.set_parser(:shell, &List.wrap/1)
  Cogs.def shell(cmdline) do
    if Utils.is_admin?(message) do
      splitted = String.split cmdline, " ", parts: 2
      if Enum.count(splitted) < 2 do
        [command] = splitted
        args = []
      else
        [command, args] = splitted
        args = String.split args
      end

      try do
        {out, err_code} = System.cmd(command, args, stderr_to_stdout: true)
        Cogs.say "error code: #{err_code}\n```\n#{out}\n```"
      rescue
        e -> Cogs.say "Error while running the command: #{inspect e}"
      end
    else
      Cogs.say "dont hax me u fucking cunt"
    end
  end

end
