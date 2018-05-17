import strutils
import os

type
  Mutable = ref object of RootObj 
    row: int
    col: int

var grid: array[9, array[9, int]]
var mutables: seq[Mutable]

proc recSolve(i: int, j: int, back: bool)
proc printGrid()

proc checkLine(i: int, p: int, x: int): bool =
  for j in 0..high(grid[i]):
    if grid[i][j] == x:
      return false
  return true

proc checkCol(j: int, x: int): bool =
  for i in grid:
    if i[j] == x:
      return false
  return true 

proc checkSquare(i: int, j: int, x: int): bool =
  let 
    a = i mod 3
    b = j mod 3
    c = i - a
    d = j - b

  for it in c..(c + 2):
    for jt in d..(d + 2):
      if grid[it][jt] == x:
        return false
  return true

proc check(i: int, j: int, minimum: int): int =
  for x in (minimum + 1)..9:
    let
      a = checkLine(i, j, x)
      b = checkCol(j, x)
      c = checkSquare(i, j, x)
    if a and b and c:
      return x
  return -1

proc find_zeros(): seq[Mutable] =
  mutables = newSeq[Mutable](0)
  for i in 0..high(grid):
    for j in 0..high(grid[i]):
      if grid[i][j] == 0:
        var mutable: Mutable = Mutable(row: i, col: j)
        mutables.add(mutable)
  return mutables

proc isMutable(i: int, j: int): bool =
  result = false
  for mutable in mutables:
    if mutable.row == i and mutable.col == j:
      result = true

#[
proc solve() =
  var 
    istep_back = 0
    jstep_back = 0
  for i in low(grid)..high(grid):
    for j in low(grid[i])..high(grid[i]):
      var x = check(i, j, grid[i][j])
      while not isMutable(i - istep_back, j - jstep_back) and x == -1:
        if j - jstep_back > 0:
          jstep_back = jstep_back + 1
        else:
          istep_back = istep_back + 1
          jstep_back = 8 - j
        echo "i : ", i, " j : ", j, " istep : ", istep_back, " jstep : ", jstep_back
        x = check(i - istep_back, j - jstep_back, grid[i - istep_back][j - jstep_back])
      grid[i][j] = x
]#

proc goBack(i: int, j: int) =
  if j > 0:
    recSolve(i, j - 1, true)
  else:
    recSolve(i - 1, 8, true)

proc goForwards(i: int, j: int) =
  if j < 8:
    recSolve(i, j + 1, false)
  else:
    recSolve(i + 1, 0, false)

proc printMutables() =
  echo "\n"
  for i in mutables:
    stdout.write "i : ", i.row, " j : ", i.col, " "

proc recSolve(i: int, j: int, back: bool) =
  if not isMutable(i, j):
    if back:
      goBack(i, j)
    else:
      if i == 8 and j == 8:
        return
      goForwards(i, j)
  else:
    let 
      x = check(i, j, grid[i][j])
    if x != -1:
      grid[i][j] = x
      if i == 8 and j == 8:
        return
      goForwards(i, j)
    else:
      grid[i][j] = 0
      if i == 0 and j == 0:
        return
      goBack(i, j)

proc readGrid(filename: string) =
  var f: File
  if not open(f, filename):
    quit("The file " & filename & " can't be opened", 1)
  let s = readAll(f)
  let spl = split(s, {'\n'})
  for i in 0..high(spl):
    let spl_white = split(spl[i])
    for j in 0..high(spl_white):
      if spl_white[j] == "":
        continue
      grid[i][j] = parseInt(spl_white[j])

proc main(filename: string) =
  readGrid(filename)
  mutables = find_zeros()
  recSolve(0, 0, false)
  #solve()
  printGrid()

proc printGrid() =
  for i in grid:
    if i != grid[0]:
      echo "\n"
    for j in i:
      stdout.write $j & " "

proc printMain() =
  mutables = find_zeros()
  printGrid()

if paramCount() != 1:
  echo "USAGE : ", paramStr(0), " filename"
else:
  main(paramStr(1))
