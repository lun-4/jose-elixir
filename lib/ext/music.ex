defmodule Music do
  alias Alchemy.Client
  alias Alchemy.Voice
  
  def context(guild, message) do
    states = guild.voice_states
    state = Enum.find(guild.voice_states, fn vstate ->
      vstate.user_id == message.author.id
    end)

    if state == nil do
      {:error, "No state found"}
    else
      {:ok, state}
    end
  end

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.set_parser(:play, &List.wrap/1)
    Cogs.def play(url) do
      {:ok, guild} = Cogs.guild()

      case Music.context(guild, message) do
        {:ok, state, pid} ->
          :ok = Queue.queue(pid, url)

          status = Voice.join(guild.id, state.channel_id)
          IO.inspect status
          Voice.play_url(guild.id, url, vol: 100)
        {:error, msg} ->
          Cogs.say msg
      end

      Cogs.say "playing"
    end

    Cogs.def current do
      {:ok, guild_id} = Cogs.guild_id()

      c = Voice.which_channel(guild_id)
      case c do
        nil -> Cogs.say "nothing"
        channel_id -> 
          queue = Queue.Registry.find(guild_id)
          current_song = Queue.current(queue)
          Cogs.say "plaing #{current_song} in <##{channel_id}>"
      end
    end

    Cogs.def leave do
      {:ok, guild_id} = Cogs.guild_id()

      case Voice.stop_audio(guild_id) do
        {:error, e} -> Cogs.say e
        :ok -> Cogs.say "ok stop audio"
      end

      case Voice.leave(guild_id) do
        {:error, e} -> Cogs.say e
        :ok -> Cogs.say "ok voice leave"
      end
    end

  end
end

defmodule Queue do
  @moduledoc """
  Queue genserver for a guild.

  This stores the state about a guild's
  queue, the current song, the next on the playlist,
  etc.
  """
  use GenServer

  @spec start(String.t) :: {:ok, pid()} | {:error, String.t}
  def start(guild_id) do
    GenServer.start(__MODULE__, guild_id, name: guild_id)
  end

  @doc """
  Get the current song the guild is playing
  on its queue.
  """
  @spec current(pid()) :: {:ok, String.t} | {:error, String.t}
  def current(pid) do
    GenServer.call(pid, {:current})
  end

  @doc """
  Mark the current song as finished,
  move to the next one.

  This should call Alchemy's Voice.stop_audio
  then the voice manager process calls Voice.play_url
  again.
  """
  @spec finish(pid()) :: {:ok, String.t} | {:error, String.t}
  def finish(pid) do
    GenServer.call(pid, {:finish})
  end

  @def """
  Queue a song.
  """
  @spec queue(pid(), String.t) :: :ok
  def queue(pid, url) do
    GenServer.call(pid, {:queue, url})
  end

  # server
  def init(guild_id) do
    {:ok, %{
      #: current guild id for this queue
      :id => guild_id,

      # the actual queue, list of strings
      :queue => [],
    }}
  end
end

defmodule Queue.Registry do
  @moduledoc """
  Store all available Queue genservers.
  """
  use GenServer

  def start do
    GenServer.start(__MODULE__, %{})
  end
end

