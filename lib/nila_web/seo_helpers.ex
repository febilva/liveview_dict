defmodule OlamWeb.SeoHelpers do
  @moduledoc """
  SEO helper functions for generating structured data and meta tags
  """

  @doc """
  Generate JSON-LD structured data for dictionary entries
  """
  def dictionary_entry_json_ld(english_word, meanings_list) do
    definitions =
      meanings_list
      |> Enum.map(fn entry ->
        %{
          "@type" => "DefinedTerm",
          "name" => english_word,
          "description" => entry.malayalam_definition,
          "inDefinedTermSet" => %{
            "@type" => "DefinedTermSet",
            "name" => "Nila Malayalam Dictionary",
            "inLanguage" => "ml"
          },
          "partOfSpeech" => entry.part_of_speech || "unknown"
        }
      end)

    %{
      "@context" => "https://schema.org",
      "@type" => "DefinedTerm",
      "name" => english_word,
      "inLanguage" => "en",
      "hasDefinition" => definitions,
      "isPartOf" => %{
        "@type" => "Dictionary",
        "name" => "Nila Malayalam Dictionary",
        "description" => "Free English to Malayalam dictionary",
        "inLanguage" => ["en", "ml"],
        "url" => "https://niladict.in"
      }
    }
    |> Jason.encode!()
    |> Phoenix.HTML.raw()
  end

  @doc """
  Generate meta description for a specific word search
  """
  def word_meta_description(english_word, meanings_list) when length(meanings_list) > 0 do
    first_meaning = List.first(meanings_list)
    malayalam_meaning = first_meaning.malayalam_definition |> String.slice(0, 100)

    "#{english_word} meaning in Malayalam: #{malayalam_meaning}... | Free English Malayalam Dictionary - Nila നിള"
  end

  def word_meta_description(english_word, _meanings_list) do
    "Search meaning of '#{english_word}' in Malayalam | Free English Malayalam Dictionary - Nila നിള"
  end

  @doc """
  Generate page title for word search
  """
  def word_page_title(english_word, meanings_list) when length(meanings_list) > 0 do
    "#{english_word} Meaning in Malayalam | നിള മലയാളം നിഘണ്ടു"
  end

  def word_page_title(english_word, _meanings_list) do
    "#{english_word} - Malayalam Dictionary | നിള മലയാളം നിഘണ്ടു"
  end

  @doc """
  Generate breadcrumb JSON-LD
  """
  def breadcrumb_json_ld(current_word \\ nil) do
    items = [
      %{
        "@type" => "ListItem",
        "position" => 1,
        "name" => "Home",
        "item" => "https://niladict.in"
      }
    ]

    items = if current_word do
      items ++ [
        %{
          "@type" => "ListItem",
          "position" => 2,
          "name" => "#{current_word} meaning in Malayalam",
          "item" => "https://niladict.in?q=#{URI.encode(current_word)}"
        }
      ]
    else
      items
    end

    %{
      "@context" => "https://schema.org",
      "@type" => "BreadcrumbList",
      "itemListElement" => items
    }
    |> Jason.encode!()
    |> Phoenix.HTML.raw()
  end

  @doc """
  Generate FAQ JSON-LD for common questions
  """
  def faq_json_ld do
    %{
      "@context" => "https://schema.org",
      "@type" => "FAQPage",
      "mainEntity" => [
        %{
          "@type" => "Question",
          "name" => "How to use Nila Malayalam Dictionary?",
          "acceptedAnswer" => %{
            "@type" => "Answer",
            "text" => "Simply type any English word in the search box to find its Malayalam meaning and translation. Nila dictionary provides instant results with proper Malayalam script."
          }
        },
        %{
          "@type" => "Question",
          "name" => "Is Nila Malayalam Dictionary free?",
          "acceptedAnswer" => %{
            "@type" => "Answer",
            "text" => "Yes, Nila Malayalam Dictionary is completely free to use. You can search for English to Malayalam translations without any registration or payment."
          }
        },
        %{
          "@type" => "Question",
          "name" => "What languages does Nila Dictionary support?",
          "acceptedAnswer" => %{
            "@type" => "Answer",
            "text" => "Nila Dictionary specializes in English to Malayalam translation. It helps users find Malayalam meanings for English words with accurate definitions in Malayalam script."
          }
        },
        %{
          "@type" => "Question",
          "name" => "Who can use this Malayalam dictionary?",
          "acceptedAnswer" => %{
            "@type" => "Answer",
            "text" => "This dictionary is perfect for Kerala students, Malayalam learners, professionals, and anyone who needs English to Malayalam translation. It's especially useful for people learning Malayalam language."
          }
        }
      ]
    }
    |> Jason.encode!()
    |> Phoenix.HTML.raw()
  end
end
