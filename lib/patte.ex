defmodule Patte do
  @moduledoc """
  Provides with various functions for handling and creating Decks
  """

  @doc """
  Creates a Deck
  ## Example
      iex> Patte.createDeck
  """
  def createDeck do
    numValues = [
      "Ace",
      "Two",
      "Three",
      "Four",
      "Five",
      "Six",
      "Seven",
      "Eight",
      "Nine",
      "Ten",
      "Jack",
      "Queen",
      "King"
    ]

    suitValues = ["Hearts", "Diamonds", "Spades", "Clubs"]

    for num <- numValues, suit <- suitValues do
      {
        num,
        suit
      }
    end
  end

  @doc """
  Shuffles/Randomizes a Deck
  ## Example
      iex> Patte.shuffleDeck(Patte.createDeck)
  """
  def shuffleDeck(deck) do
    Enum.shuffle(deck)
  end

  @doc """
  Checks if a  Particular Card is present in the Deck
  ## Example
      iex> deck=Patte.createDeck
      iex> Patte.isPresent?(deck,{"Nine","Hearts"})
      true
  """
  def isPresent?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
  Return a tuple with dealt hand at index 0 and rest of deck  at index 1.

  Takes an argument of  `size`  to generate the hand of specific size.

  ## Example
        iex> deck=Patte.createDeck
        iex> {hand,_rest}=Patte.deal(deck,1)
        iex> hand
        [{"Ace", "Hearts"}]
  """
  def deal(deck, size) do
    Enum.split(deck, size)
  end

  @doc """

  Shorthand for creating a deck,shuffling, and then creating the hand.

  Takes the Argument for `handSize`

  ## Example
        iex> hand=Patte.createHand(7)

  """
  def createHand(handSize) do
    createDeck() |> shuffleDeck() |> deal(handSize)
  end

  @doc """
  Returns the  path to deck files
  """
  def genPath(fileName) do
    Path.absname("decks/#{fileName}.deck")
  end

  @doc """
  Save the deck to Local Storage

  Takes the argument of `deck` and `fileName`

  ## Example
        iex> deck=Patte.createDeck
        iex>Patte.save(deck,"myDeck")
        :ok
  """

  def save(deck, fileName) do
    path = genPath(fileName)
    binary = :erlang.term_to_binary(deck)
    File.mkdir_p!(Path.dirname(path))
    File.write(path, binary)
  end

  @doc """
  Loads a presaved deck from Local Storage

  Takes an argument for `fileName`

  ## Example
        iex>deck=Patte.load("myDeck")
  """

  def load(fileName) do
    path = genPath(fileName)

    case File.read(path) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _reason} -> "Requested File not Found"
    end
  end

  @doc """
  Deletes the requested deck from Local Storage

  Takes an argument for `fileName`

  ## Example
        iex>deck=Patte.delete("myDeck")
  """
  @spec delete(charlist()) :: :ok
  def delete(fileName) do
    path = genPath(fileName)
    File.rm!(path)
  end

  def listSavedDecks do
    Path.wildcard(Path.absname("decks/*.deck"))
    |> Enum.map(fn path -> Path.basename(path) |> String.replace_trailing(".deck", "") end)
  end
end
