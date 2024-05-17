-- Checagem de primo, (simples mas lenta)
factors :: Int -> [Int]
factors n = [x | x <- [1..n], mod n x == 0]

isPrime :: Int -> Bool
isPrime n = factors n == [1,n]


-- aplicando filtro de primos
generatePrimes :: Int -> Int -> [Int]
generatePrimes x y = filter isPrime [x..y]

-- Calcula a diferença entre a tail da lista de primos e a lista de primos 
-- (obrigatóriamente nesta ordem). Assim, calculando o intervalo entre um primo e outro
-- ex: tail lista = [7, 11]    |     lista = [5, 7, 11]    ->  
-- result = [7 - 5, 11 - 7] = [2, 4]
consecutiveDiffs :: [Int] -> [Int]
consecutiveDiffs prime_list = zipWith (-) (tail prime_list) prime_list

-- aplicando as funções criadas para obter o resultado
maxInterval :: Int -> Int -> Int
maxInterval x y =
  let primes = generatePrimes x y
  
  -- caso só exista 1 primo na lista de diferenças o maior intervalo é 0
  in if length primes < 2 then 0 else maximum (consecutiveDiffs primes)


main :: IO ()
main = do
  input1 <- getLine
  input2 <- getLine
  
  let x = (read input1 :: Int)
  let y = (read input2 :: Int)
  
  print $ maxInterval x y