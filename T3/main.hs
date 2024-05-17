main :: IO ()
main = do
  -- leitura da entrada
  input <- getLine

  -- conversão de tipos, torna a entrada em uma lista de inteiros
  let lista = map read (words input) :: [Int]

  -- imprime o comprimento do segmento crescente maximo
  putStrLn $ show (compMax lista)

-- função que recebe uma lista de inteiros e retorna o comprimento do segmento crescente maximo
compMax :: [Int] -> Int
-- se a lista for vazia, o comprimento eh 0
compMax [] = 0
-- se a lista tiver ao menos um elemento, partimos para uma função auxiliar que calcula o comp maximo
compMax xs = funcAux xs 1 1
  where
    -- se a lista estiver vazia, o maximo calculado até então é o maximo final
    funcAux [] _ maximo = maximo
    -- se a lista tiver apenas um elemento, pegamos o maior numero entre o comprimento atual e o maximo
    -- calculado ate entao
    funcAux [x] compAtual maximo = max compAtual maximo
    -- se a lista tiver mais elementos:
    funcAux (x:y:xs) compAtual maximo
      -- se o proximo numero for maior que o atual, ainda estamos em um segmento crescente, entao chamamos
      -- a funcao novamente para a cauda, somando +1 no comprimento atual
      | y > x     = funcAux (y:xs) (compAtual + 1) (max compAtual maximo)
      -- se o proximo numero nao for maior, chamamos a funcao novamente para a cauda reiniciando 
      -- a contagem do comprimento atual, pois o segmento crescente tambem é reiniciado
      | otherwise = funcAux (y:xs) 1 (max compAtual maximo)
