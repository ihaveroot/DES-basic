![TeleBASIC](https://raw.githubusercontent.com/telehack-foundation/.github/main/profile/svg/telebasic.svg)

# DES-basic
				                            .,,,.
				                        .zd$$$$$$$c,
				                    .zd$$$$$$$$$$$$$$c,
				                 .e$$$$$$$$$$$$$$$$$$$$$$$$$$cc,
				                d$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$c    .,,,.
				               d$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$c."$$$$$$bc.
				               `$$$$$$$$$$$$$$$$$$$$$$$$???""""""????" $$$$$$$$$bc.
				                `?$$$$$$P"""""""""""              zcze$$$$$$$$$$$$$bc
				                   "?$$ ,c$$$cccc, c             z$$$$$$$$$$$$$$$$$$$$c
				                     `?b,"?$$$$$$$.`b           J$$$$$$$$$$$$$$$$$$$$$$P
				                        "?c "?$$$$$ `b         <$$$$$$$$$$$$$$$$$$$$$P"
				                           "c, "?$$b 3L        $$$$$$$$$$$$$$$$$PF""
				                             "?b. "$,`$.      <$$$$$$$$$$$$P""
				                               `?b `? ?$      <$$$$$$$$$""  ,cd"
				                            `"==,J$c  "?r     `$$$$$$P" ,c$$P",=
				                          """?4cd$$$b  .       `???"  ,d$P",r"
				                       ===cccc,_ "?$$$$$b       , ,c$P",cP""
				                 .,-======ccccJC?$bd$$$$$$.    z" "',cP"
				                             `"?$$$$$$$$$$$. F F .d$"
				 `-.                           4/?$$$$$$$$$$$"  J$F
				    `.                          3c ?$$$$$$$$$. .,,,,.
				      "\      ,d$$$bcc$c ,ccc,  J$> ??$$$$$$$$$$$$$$$$??=
				`"=,.   ".  ,?P"""")3$$F<$$$$F  $E,  `""?$$$$$$$$$$P???b,
				     `-,  `,c$$"',,`"?$ $" `$$. """  "?b,`$$$$$$$$$bc,  `"=
				        " J$$P <!!!!>. .`c,=),ccc,.     ?,`$$$$$$$F?$$$c
				         d$$P !!!!!!!!> ?, d  3$$$$c $c  $ ?$?$?$$$c "?$c
				        <$$$$ `!!!!!!!! <$."?$$$$$$",$$,$$r`F   3,"$$.  `?
				         ?$$$b. `''!!' ,$$$ bccccczd$$$$$$  `   `?  "$
				          "$$$ ,c,,,,c$$$$$ `,, `$$$$$$$$$
				            "" 4$$$$$$$$$$P <!!! $$$$$$$$$r
				           d$ c,"?$$$$$$$" ;!!' ,$$$$$$$$L
				           "",$F     ""  -''',cd$$$$$$$?r'
				              "    .`"?ccd$$$$$$$$$$$F$ /   .
				                .;<!!!;,`?$$$$$$$$P??  .,;!!>
				                  ``'<!!!;`?$$$$$ ;;<!!!!!!!>
				                       `<!, $$$$$ !'!!!!!'``
				               .,.       `! <$$"",;;; `;;<>,
				              !!!!!!!>;,, `,;   ` ,;!> !!!!!;
				              <!!!!!!''``` `!  ;!!!!!! `!!!!!;
				               <!!!!><!!!!!   `!!!!!!! <!!!!!!
				                `<!!!!!!!`,db  `!!!!!  !!!!!!!.
				              ;!;  `''' , $$$$  `'!!  <!!!!!!!>




The DES algorithm written in TeleBASIC


| Table of Contents | Description                 |
|-------------------|-----------------------------|
| [Intro](https://github.com/ihaveroot/DES-basic/edit/main/README.md#intro) | Some words about the program|
| [Algorithm](https://github.com/ihaveroot/DES-basic/edit/main/README.md#algorithm) | The DES Algorithm |
| [Program](https://github.com/ihaveroot/DES-basic/edit/main/README.md#the-program) | The program's function |




# Intro
   Use the flag `--help` for help. I've left a nice description, on what you can do, and what it's capable of.
   
   Pretty self explanatory, you probably know about DES, or have heard about this encryption.
   Though, If you don't know about DES, then I'd like to point you towards the NIST. They have a lovely whitepaper archived about it [ref: FIPS 46-3](https://csrc.nist.gov/csrc/media/publications/fips/46/3/archive/1999-10-25/documents/fips46-3.pdf "FIPS 46-3 DES Algorithm pdf"), it's also what I've referenced when I had created this.
   
   The paper is pretty well layed out, I'm confident that you'll be able to follow it. I'm not really going to do a long writeup for this. There are comments amongst the source in case you'd like to follow along. I explain what each step is doing.
   
   I'm also disappointed that this program can't be referenced externally outside of Telehack. I wanted the ability to have the output used elsewhere, online, but I tried my output on CyberChef, and it didn't yield my input result :( I think that they're using TripleDES. A little disappointing :(
   
   With that being said, I'll consider this a Telehack port. Though it does follow the encryption algorithm true to the whitepaper and to the best of Telebasic's capability.
   
   I also wanted the ability to call this program within another. You may find a way to do so, run it once, you'll see the output. You could do something like `TH_EXEC "des -e" STR$ " -k " KEY$` though I'm sure you'll find a way if you so desire.
   

# The Algorithm
DES is a block cipher, where it takes in an input of 64 bit groups, and encrypts each of those groups with a key. This program does check whether the key is in hexadecimal, this matters because 64 bits in Hexadecimal is 16 characters long, whereas in ASCII this is only a length of 8 characters. DES creates 16 subkeys, where of those 64 bits, only 48 are used for the encrypting/decrypting process. For each block in our input we encrypt/decrypt each block 16 times with our key. Going though our substitution tables, and permutation tables, to our output. our encryption output will be in Hexadecimal, and our decryption, plaintext.

The ecryption, and decryption process uses the same formula. the only difference being that in the decryption routine we reverse the key order (key1 = key16, key2 = key15, key3 = key14 etc).


# The program

In the [ecryption routine](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L214), the program starts with our [key creation](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L137). If the key is in hexadecimal, then we convert from [Hexadecimal to Binary](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L161), If the key is in ASCII then we simply do an [ASCII to binary](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L176) conversion. It's important to note that I've chosen to [Pad our key](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L155) with the letter `A` if the key length does not reach our desired length. If the key is longer (either in Hexadecimal, or ASCII) then we [truncate our key](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L158).

In the [decryption routine](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L415), we do the same for out key creation, though we reverse the order of our keys.

Continuing on for our key creation, we then loop 16 times to [create each of our subkeys](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L181) where each key goes through the [PC-1 table](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L13), to give a key length of 56 bits. Afterwards it goes through a [Left shift](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L14), where the iteration number pertains to the corresponding key array (eg. key1 = 1 left shit, key2 = 1 left shift, key3 = 2 left shifts etc). We apply the [PC-2 table](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L15) to give us na output of 48 bits.

After the key creation we [split our message](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L226) into our blocks 8 characters each, where we do an [ASCII to Binary](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L240) conversion for each block. For the decryption process, we do a [Hexadecimal to Binary](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L450) conversion, and [split our blocks](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L441) into 64 bits each. Since we are decrypting, the input should be in Hexadecimal. If the length of the input message is not a multiple of 8 (for encrypting) then I have chosen to pad the input message with `+`. I found it less likely to have an input with trailing +'s so this is what I have chosen to do. In the decryption process we sed out the trailing +'s for our plaintext.

After all of our checks, creating our keys and blocks, we start our encryption/decryption process. 

Found below pertains to steps in the [function](https://github.com/ihaveroot/DES-basic/blob/d34a7659cfe4d424369c0e0a24ee8c5e2d08e0eb/src/des.bas#L247) I have written:
```
For each message block
  apply an inital permutation to the block using the IP table
  Split the current block into 32 bits each for the left and right side (L0, R0)
  
  For each subkey (K1 - K16)
    Expand our right side to 48 bits with the E-BIT selection table E(Rn-1)
    XOR our right side with our current key (Kn XOR E(Rn-1))
    Split our result into 8 groups of 6 bits each
    
    For each group of 8 bits
     Subsitute the positional group with our corresponding Substitution box (S1(g1), S2(g2), S3(g3)...)

    Permutate the subsituted result with the P table for an output of 32 bits
    XOR Ln-1 with our P table result (Ln-1 XOR Kn(E(Rn-1)))
    Let Rn+1 equal the XOR result
    Let Ln equal Rn+1
  Next Key
  
  Reverse order of left and right side (R16, L16)
  Apply Final permutation with IP-1 table
  If we are encrypting then convert from binary to Hexadecimal
  If we are decrypting then convert from binary to ASCII
Next block
```

Pretty simple right? hope you found this easy to follow, I wanted to write a more "modern" encryption algorithm in TeleBASIC, so I'm pretty happy with how it turned out, it works pretty good :)
    
  
    
