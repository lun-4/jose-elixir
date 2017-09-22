defmodule Utils do
  def get_important(lst) do
    l = Enum.count(lst)
    Enum.slice(lst, 1, l - 2)
  end

  def strip_markup(code) do
    if String.starts_with?(code, "```") and String.ends_with?(code, "```") do
      String.split(code, "\n")
      |> Utils.get_important
      |> Enum.join("\n")
    else
      String.trim(code)
    end
  end

  def is_admin?(message) do
    admins = Application.fetch_env!(:jose, :admins)
    Enum.find(admins, fn(x) -> message.author.id == x end) != nil
  end

  def user_id(string) do
    starting_slice = cond do
      String.starts_with?(string, "<@!") -> 3
      String.starts_with?(string, "<@") -> 2
      true -> -1
    end

    case starting_slice do
      -1 ->
        {:error, "this is not a mention"}
      _ ->
        len = String.length string
        uid = String.slice string, starting_slice..(len - 2)

        {:ok, uid}
    end
  end


  @doc """
  Get a user's avatar URL in discord.
  """
  def user_avatar(user) do
    avatar_type = if String.starts_with?(user.avatar, "a_") do
      "gif"
    else
      "png"
    end

    case avatar_type do
      "gif" ->
        url = user
        |> Alchemy.User.avatar_url(avatar_type, 128)

        len = String.length url

        String.slice(url, 0..(len - 10))
      _ ->
        user
        |> Alchemy.User.avatar_url(avatar_type, 1024)
    end
  end

end
