main :: IO ()
main = do
  input <- getLine

  let lista = map read (words input) :: [Int] -- le a lista de numeros da linha de input

  putStr $ showFrames lista 1                 
  putStrLn $ show (calculateScore lista [] 1)

-- Função que print os frames (rodadas) formatados
--       argumentos: [listaPinosDerrubados] ; frameAtual
showFrames :: [Int] -> Int -> String
showFrames [] _ = "" -- caso base (que não precisa ser chamado pois com a contagem de frames é garantido que termine no 10)
showFrames (h : t) frame
  | frame == 10 = showLast (h : t) (-1) -- trata a ultima rodada separadamente
  | h == 10 = "X _ | " ++ showFrames t (frame + 1) -- strike printa X e passa para proximo frame
   -- spare = primeiro valor e no lugar do segundo é o caracter '/'
  | h + head t == 10 = show h ++ " / | " ++ showFrames (tail t) (frame + 1)
  | otherwise = 
    show h ++ " " -- primeiro valor do frame
    ++ show (head t)  -- segundo valor do frame 
    ++ " | " -- printa o fim do frame
    ++ showFrames (tail t) (frame + 1) -- chamada recursiva
  
-- Função que gera a string formatada do último frame 
showLast :: [Int] -> Int -> String
showLast [] _= "| "      -- caso base = caracter que finaliza a string da última rodada
showLast (h : t) prev
  -- obs: é preciso passar -1 pois no caso onde o spare é feito por (0, 10) 
  -- se a próxima jogada fosse 0 o seria tratado como spare
  | h + prev == 10 = "/ " ++ showLast t (-1) -- caso a bola atual seja um spare.
  | h == 10 = "X " ++ showLast t (-1) -- caso seja um strike (-1 passado pelo mesmo motivo do spare)
  | otherwise = show h ++ " " ++ showLast t h -- caso a bola atual não seja um spare ou strike apenas mostra seu valor

-- função que calcula o score total do jogador
--       argumentos: [listaPinosDerrubados] ; lista dos bonus ativos ; frameAtual
calculateScore :: [Int] -> [Int] -> Int -> Int
calculateScore [] _ _ = 0 -- caso base (não é necessário por conta da contagem de frame)
calculateScore (h : t) bonus frame
  -- ultimo frame é separado por poder ter numero diferente de bolas e por não adicionar bonus entre as jogadas
  | frame == 10 =
    h * bonusMultiplier bonus -- valor da primeira bola (com bonus se algum ainda existir)
    + head t * bonusMultiplier (updateBonus bonus) -- valor da segunda bola (com bonus se algum ainda existir)
    + if h + head t >= 10 then head (tail t) else 0 -- caso seja um spare ou strike existe uma terceira bola
  | h == 10 = -- strike
    10 * bonusMultiplier bonus -- valor do strike com possível bonus
    + calculateScore t (2 : updateBonus bonus) (frame + 1) -- adiciona 2 rounds bonus e passa pro próximo frame com bonus atualizado
  | h + head t == 10 = -- spare
    h * bonusMultiplier bonus -- valor da primeira bola com possível bonus
    + head t * bonusMultiplier (updateBonus bonus) -- valor da segunda bola com possível bonus com o bonus atualizado
    -- adiciona 1 round bonus e para para o próximo frame com bonus atualizado
    + calculateScore (tail t) (1 : updateBonus (updateBonus bonus)) (frame + 1) -- adiciona 1 round bonus e passa para o próximo frame com bonus atualizado
  | otherwise = -- não é strike nem spare
    h * bonusMultiplier bonus -- valor da primeira bola com possível bonus
    + head t * bonusMultiplier (updateBonus bonus) -- valor da segunda bola com possível bonus
    + calculateScore (tail t) (updateBonus (updateBonus bonus)) (frame + 1) -- atualiza bonus e passa para o próximo frame

-- função que atualiza o bonus
-- o bonus é uma lista de inteiros, 2 ou 1 que são acrescentados pelos strikes e spares
-- a atualização é definida por pegar cada valor da lista e subtrair 1 de cada bonus ativo depois excluir os elementos 0
updateBonus :: [Int] -> [Int]
updateBonus [] = []
updateBonus l = filter (> 0) [x - 1 | x <- l]

-- função que calcula o multiplicador do bonus
-- argumentos:    lista de bonus ativos
bonusMultiplier :: [Int] -> Int
bonusMultiplier [] = 1 -- caso nenhum bonus ativo o multiplicador é 1
bonusMultiplier l = 1 + length l -- caso exista bonus o multiplicador é 1 + o tamanho da lista dos bonus
