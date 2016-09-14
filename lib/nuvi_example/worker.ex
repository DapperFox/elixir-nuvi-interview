defmodule NuviExample.Worker do
  def start_link do
    pid = spawn_link &__MODULE__.get_zips/0
  end

  def get_zips do
    IO.inspect("getting zips")
  end
end
