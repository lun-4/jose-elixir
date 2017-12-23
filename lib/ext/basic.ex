defmodule Basic do
  alias Alchemy.Embed
  require Alchemy.Embed

  defmodule Commands do
    use Alchemy.Cogs

    @red_embed %Alchemy.Embed{color: 0x660099}

    @doc """
    Show help about all commands in José.
    """
    Cogs.def help do
      e = %Alchemy.Embed{description: ""}
      |> Embed.title("Command list")

      all = Alchemy.Cogs.all_commands
      
      reduced = all
      |> Map.keys
      |> Enum.map_reduce(e, fn (key, e) ->
        value = Map.get(all, key)

        #module = elem value, 0
        arity = elem value, 1
        name = elem value, 2

        formatted = "#{name}/#{arity}"
        new_embed = Embed.description(e, "#{e.description}\n#{formatted}")
        {formatted, new_embed}
      end)

      help_embed = elem reduced, 1
      Embed.send help_embed

    end

    @doc """
    Erlang VM stats.
    """
    Cogs.def vmstats do
      memories = :erlang.memory()
      processes = length :erlang.processes()
      {{_, io_input}, {_, io_output}}  = :erlang.statistics(:io)
      
      mem_format = fn
        mem, :kb -> "#{div(mem, 1000)} KB"
        mem, :mb -> "#{div(mem, 1_000_000)} MB"
      end

      info = [
        {"Processes", "#{processes}"},
        {"Total Memory", mem_format.(memories[:total], :mb)},
        {"IO Input", mem_format.(io_input, :mb)},
        {"Process Memory", mem_format.(memories[:processes], :mb)},
        {"Code Memory", mem_format.(memories[:code], :mb)},
        {"IO Output", mem_format.(io_output, :mb)},
        {"ETS Memory", mem_format.(memories[:ets], :kb)},
        {"Atom Memory", mem_format.(memories[:atom], :kb)}
      ]
      Enum.reduce(info, @red_embed, fn {name, value}, embed ->
        Alchemy.Embed.field(embed, name, value, inline: true)
      end)
      |> Embed.send
    end
  end
end
