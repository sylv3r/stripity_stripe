defmodule Stripe.Request do
  alias Stripe.Changeset
  alias Stripe.Converter

  @spec create(String.t, map, map, Keyword.t) :: {:ok, map} | {:error, Stripe.api_error_struct}
  def create(endpoint, changes, schema, opts) do
    body =
      changes
      |> Changeset.cast(schema, :create)

    case Stripe.request(:post, endpoint, body, %{}, opts) do
      {:ok, result} -> {:ok, Converter.stripe_map_to_struct(result)}
      {:error, error} -> {:error, error}
    end
  end

  @spec create_file_upload(String.t, Path.t, String.t, Keyword.t) :: {:ok, struct} | {:error, Stripe.api_error_struct}
  def create_file_upload(endpoint, filepath, purpose, opts) do
    body = {:multipart, [{"purpose", purpose}, {:file, filepath}]}
    case Stripe.request_file_upload(:post, endpoint, body, %{}, opts) do
      {:ok, result} -> {:ok, Converter.stripe_map_to_struct(result)}
      {:error, error} -> {:error, error}
    end
  end

  @spec retrieve(String.t, Keyword.t) :: {:ok, struct} | {:error, Stripe.api_error_struct}
  def retrieve(endpoint, opts) do
    case Stripe.request(:get, endpoint, %{}, %{}, opts) do
      {:ok, result} -> {:ok, Converter.stripe_map_to_struct(result)}
      {:error, error} -> {:error, error}
    end
  end

  @spec retrieve_file_upload(String.t, Keyword.t) :: {:ok, struct} | {:error, Stripe.api_error_struct}
  def retrieve_file_upload(endpoint, opts) do
    case Stripe.request_file_upload(:get, endpoint, %{}, %{}, opts) do
      {:ok, result} -> {:ok, Converter.stripe_map_to_struct(result)}
      {:error, error} -> {:error, error}
    end
  end

  @spec update(String.t, map, map, list, Keyword.t) :: {:ok, struct} | {:error, Stripe.api_error_struct}
  def update(endpoint, changes, schema, nullable_keys, opts) do
    body =
      changes
      |> Changeset.cast(schema, :update, nullable_keys)

    case Stripe.request(:post, endpoint, body, %{}, opts) do
      {:ok, result} -> {:ok, Converter.stripe_map_to_struct(result)}
      {:error, error} -> {:error, error}
    end
  end

  @spec delete(String.t, Keyword.t) :: :ok | {:error, Stripe.api_error_struct}
  def delete(endpoint, opts) do
    case Stripe.request(:delete, endpoint, %{}, %{}, opts) do
      {:ok, _} -> :ok
      {:error, error} -> {:error, error}
    end
  end
end
