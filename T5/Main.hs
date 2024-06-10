module Main where

import Data.List
import Data.Ord

data CountryRecord = CountryRecord         -- tipo de dado para os registros do csv
  { country :: String,
    confirmed :: Int,
    deaths :: Int,
    recovery :: Int,
    active :: Int
  }
  deriving (Show)

main :: IO ()
main = do
  input <- getLine

  let lista = map read (words input) :: [Int] -- le a lista de numeros da linha de input
  let (n1 : n2 : n3 : n4 : _) = lista -- pega os 4 primeiros numeros da lista
  contents <- readFile "dados.csv"
  let csvLines = lines contents

  let records = map (parseCsvRecord . split ',') csvLines

  print $ operation1 n1 records
  print $ operation2 n2 n3 records
  putStr $ operation3 n4 records


-- Função que filtra os records com confirmed > n1 e depois soma os active
operation1 :: Int -> [CountryRecord] -> Int
operation1 n1 = sum
  . map active
    . filter (\record -> confirmed record > n1)

-- Função que filtra os n2 records com maior active e recovery > n3 e depois soma os  
operation2 :: Int -> Int -> [CountryRecord] -> Int
operation2 n2 n3 = sum       -- soma as mortes
  . map deaths
    . take n3                -- pega os n3 primeiros dessa nova ordenação
      . sortOn confirmed     -- organiza esses n2 records de acordo com a coluna confirmed
        . take n2            -- pega os n2 primeiros elementos dos records ordenados
            . sortOn (Down . active)  -- ordena os records com base no active

-- função que pega os n4 maiores confirmed, depois ordena alfabéticamente e concatena as palavras separadas por espaço
operation3 :: Int -> [CountryRecord] -> String
operation3 n4 = unlines   -- unlines concatena a lista de palavras separadas por quebra de linha
  . sort                     -- ordena alfabéticamente
    . map country            -- pega o nome dos países
      . take n4              -- pega os 4 primeiros elementos
          . sortOn (Down . confirmed) -- ordena os records com base no confirmed em ordem decrescente

-- separa uma string em todas substrings separadas por um caracter delimitador 
split :: Char -> String -> [String]
split _ "" = [""]
split delimiter str = foldr fn [""] str  -- aplica a função auxiliar em todos elementos da direita pra esquerda
  where
    fn c acc@(x : xs)
      | c == delimiter = "" : acc   -- se o delimitador for encontrado adiciona uma nova string vazia no acumulador
      | otherwise = (c : x) : xs    -- se não adiciona o caracter na primeira string do acumulador
    fn _ [] = []

-- função que transforma uma linha do csv em um CountryRecord
parseCsvRecord :: [String] -> CountryRecord
parseCsvRecord (xcountry : xconfirmed : xdeaths : xrecovery : xactive : _) =
  CountryRecord
    { country = xcountry,
      confirmed = read xconfirmed :: Int,
      deaths = read xdeaths :: Int,
      recovery = read xrecovery :: Int,
      active = read xactive :: Int
    }
parseCsvRecord _ = error "Invalid CSV format"  -- não deve existir uma linha csv que não tenha exatamente 5 colunas

