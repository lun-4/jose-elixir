defmodule JoseAdmin do
  use Alchemy.Cogs
  require Logger
  
  Cogs.set_parser(:shell, &List.wrap/1)
  Cogs.def shell(cmdline) do
    if Utils.is_admin?(message) do
      splitted = String.split cmdline, " ", parts: 2

      [command, args] = if Enum.count(splitted) < 2 do
        [cmd] = splitted
        [cmd, []]
      else
        [cmd, arg] = splitted
        [cmd, String.split(arg)]
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
