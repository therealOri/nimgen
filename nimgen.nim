import std/strutils
import std/strformat
import std/httpclient
import random
import os


# You can increase the likelyhood of an option being picked by adding more and more to that option.
const uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const lowercase = "abcdefghijklmnopqrstuvwxyz"
const symbols = "!=<>'@#$%^&*()[\\],.;:-_/+?{|}`~"
const numbers = "012345678901234567890123456789"

#TODO
# - [] Add more languages and unicode characters.
# - [] Add support for unicode...Help




proc clear() =
    discard execShellCmd("clear||cls")



proc randint(min: int, max: int, num = 1): seq[string] =
    let url = fmt"https://www.random.org/integers/?num={num}&min={min}&max={max}&col=5&base=10&format=plain&rnd=new"

    let client = newHttpClient()
    let response = client.get(url)

    if response.status == "200 OK":
        var rand_numbers = response.body.splitWhitespace()
        if num > 1:
            return rand_numbers
        else:
            var rand_number = response.body.splitWhitespace()
            return rand_number
    else:
        raise newException(ValueError,
        fmt"Request failed with status {response.status}")




#get item idex of a string proc because Nim won't let me put this in the main proc...and I gave up trying.
proc rndChoice(s: string, i: int): char =
    let index = i
    result = s[index]



proc shuffleString(s: string): string =
    var chars = @s
    shuffle(chars)
    result = chars.join("")




#Main
# TODO
# - [] When more more languages are supported, add user input to allow the user to pick and choose what to use in their passwords.
proc generatePassword(length: int, howmany: int) =
    var all = ""
    const upper = true
    const lower = true
    const nums = true
    const syms = true


    if upper:
        all &= uppercase
    if lower:
        all &= lowercase
    if nums:
        all &= numbers
    if syms:
        all &= symbols


    #why the are there 2 extra characters in all?
    var len_of_all = all.len
    var len_of_all_fix = len_of_all - 2
    for x in 0..<howmany:
        var shuffled_all = shuffleString(all)
        let rnd_nums = randint(0, len_of_all_fix, length)
        var final_pass = ""
        for i in rnd_nums:
            var pick = rndChoice(shuffled_all, i.parseInt)
            final_pass &= pick
        echo fmt"Password: {final_pass}"





clear()
echo "How long do you want your password(s) to be?: "
let length = readline(stdin).parseInt
if length < 20:
    clear()
    quit("Password(s) can NOT be less than '20' in length...")



clear()
echo "How many passwords do you want to generate?: "
let howmany = readline(stdin).parseInt
if howmany < 1:
    clear()
    quit("You must generate atleast 1 password...")


clear()
echo "Generating password(s)...\n"
generatePassword(length, howmany)





