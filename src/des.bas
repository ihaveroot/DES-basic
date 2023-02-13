    DEF FNTRAVERSE$(VAR$, I) = TH_RE$(VAR$, "\w[^\,]*", I)
    DEF FNROTATE$(VAR$, I) = RIGHT$(VAR$, I MOD LEN(VAR$)) + LEFT$(VAR$, LEN(VAR$) - I MOD LEN(VAR$))
    DEF FNXOR$(VAR1$, VAR2$, VAR3$, I) = STR$(VAL(MID$(VAR1$, I, 1)) XOR VAL(MID$(VAR2$, FNTRAVERSE$(VAR3$, I), 1)))
    DEF FNXORLKER$(VAR1$, VAR2$, I) = STR$(VAL(MID$(VAR1$, I, 1)) XOR VAL(MID$(VAR2$, I, 1)))

    ' Coloring, Flair
    ESC$ = CHR$(27)
    G$ = ESC$ + "[38;5;40m"
    Y$ = ESC$ + "[38;5;11m"
    W$ = ESC$ + "[38;5;254m"

    ' The variables here pertain to the tables that DES uses, appearing in order of operation.
    PC1$ = "57,49,41,33,25,17,9,1,58,50,42,34,26,18,10,2,59,51,43,35,27,19,11,3,60,52,44,36,63,55,47,39,31,23,15,7,62,54,46,38,30,22,14,6,61,53,45,37,29,21,13,5,28,20,12,4"
    KEYLEFTSHIFT$ = "1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1"
    PC2$  = "14,17,11,24,1,5,3,28,15,6,21,10,23,19,12,4,26,8,16,7,27,20,13,2,41,52,31,37,47,55,30,40,51,45,33,48,44,49,39,56,34,53,46,42,50,36,29,32"
    IP$   = "58,50,42,34,26,18,10,2,60,52,44,36,28,20,12,4,62,54,46,38,30,22,14,6,64,56,48,40,32,24,16,8,57,49,41,33,25,17,9,1,59,51,43,35,27,19,11,3,61,53,45,37,29,21,13,5,63,55,47,39,31,23,15,7"
    EBIT$ = "32,1,2,3,4,5,4,5,6,7,8,9,8,9,10,11,12,13,12,13,14,15,16,17,16,17,18,19,20,21,20,21,22,23,24,25,24,25,26,27,28,29,28,29,30,31,32,1"

    ' Substitution row and column
    STABLEROW$    = "0000,0001,0010,0011,0100,0101,0110,0111,1000,1001,1010,1011,1100,1101,1110,1111"
    STABLECOLUMN$ = "00,01,10,11"
    ' I originally had 4 arrays for each of the Sbox tables
    ' as seperate variables:
    '  SBOX1$(1-4), SBOX2$(1-4), SBOX3$(1-4)...
    ' It seemed like a lot of overhead to call each
    '  array seperately in the enc/dec process,
    '  so I worked it out to one variable.
    ' This just keeps track of which Substitution box 
    '  array group to use later on in the enc/dec process.
    SBOXARRAY$ = "1,5,9,13,17,21,25,29"
    ' Substitution Box 1
    SBOX$(1)   = "14,4,13,1,2,15,11,8,3,10,6,12,5,9,0,7"
    SBOX$(2)   = "0,15,7,4,14,2,13,1,10,6,12,11,9,5,3,8"
    SBOX$(3)   = "4,1,14,8,13,6,2,11,15,12,9,7,3,10,5,0"
    SBOX$(4)   = "15,12,8,2,4,9,1,7,5,11,3,14,10,0,6,13"
    ' Substitution Box 2
    SBOX$(5)   = "15,1,8,14,6,11,3,4,9,7,2,13,12,0,5,10"
    SBOX$(6)   = "3,13,4,7,15,2,8,14,12,0,1,10,6,9,11,5"
    SBOX$(7)   = "0,14,7,11,10,4,13,1,5,8,12,6,9,3,2,15"
    SBOX$(8)   = "13,8,10,1,3,15,4,2,11,6,7,12,0,5,14,9"
    ' Substitution Box 3
    SBOX$(9)   = "10,0,9,14,6,3,15,5,1,13,12,7,11,4,2,8"
    SBOX$(10)  = "13,7,0,9,3,4,6,10,2,8,5,14,12,11,15,1"
    SBOX$(11)  = "13,6,4,9,8,15,3,0,11,1,2,12,5,10,14,7"
    SBOX$(12)  = "1,10,13,0,6,9,8,7,4,15,14,3,11,5,2,12"
    ' Substitution Box 4
    SBOX$(13)  = "7,13,14,3,0,6,9,10,1,2,8,5,11,12,4,15"
    SBOX$(14)  = "13,8,11,5,6,15,0,3,4,7,2,12,1,10,14,9"
    SBOX$(15)  = "10,6,9,0,12,11,7,13,15,1,3,14,5,2,8,4"
    SBOX$(16)  = "3,15,0,6,10,1,13,8,9,4,5,11,12,7,2,14"
    ' Substitution Box 5
    SBOX$(17)  = "2,12,4,1,7,10,11,6,8,5,3,15,13,0,14,9"
    SBOX$(18)  = "14,11,2,12,4,7,13,1,5,0,15,10,3,9,8,6"
    SBOX$(19)  = "4,2,1,11,10,13,7,8,15,9,12,5,6,3,0,14"
    SBOX$(20)  = "11,8,12,7,1,14,2,13,6,15,0,9,10,4,5,3"
    ' Substitution Box 6
    SBOX$(21)  = "12,1,10,15,9,2,6,8,0,13,3,4,14,7,5,11"
    SBOX$(22)  = "10,15,4,2,7,12,9,5,6,1,13,14,0,11,3,8"
    SBOX$(23)  = "9,14,15,5,2,8,12,3,7,0,4,10,1,13,11,6"
    SBOX$(24)  = "4,3,2,12,9,5,15,10,11,14,1,7,6,0,8,13"
    ' Substitution Box 7
    SBOX$(25)  = "4,11,2,14,15,0,8,13,3,12,9,7,5,10,6,1"
    SBOX$(26)  = "13,0,11,7,4,9,1,10,14,3,5,12,2,15,8,6"
    SBOX$(27)  = "1,4,11,13,12,3,7,14,10,15,6,8,0,5,9,2"
    SBOX$(28)  = "6,11,13,8,1,4,10,7,9,5,0,15,14,2,3,12"
    ' Substitution Box 8
    SBOX$(29)  = "13,2,8,4,6,15,11,1,10,9,3,14,5,0,12,7"
    SBOX$(30)  = "1,15,13,8,10,3,7,4,12,5,6,11,0,14,9,2"
    SBOX$(31)  = "7,11,4,1,9,12,14,2,0,6,10,13,15,3,5,8"
    SBOX$(32)  = "2,1,14,7,4,10,8,13,15,12,9,0,3,5,6,11"

    P$ = "16,7,20,21,29,12,28,17,1,15,23,26,5,18,31,10,2,8,24,14,32,27,3,9,19,13,30,6,22,11,4,25"
    IP1$ = "40,8,48,16,56,24,64,32,39,7,47,15,55,23,63,31,38,6,46,14,54,22,62,30,37,5,45,13,53,21,61,29,36,4,44,12,52,20,60,28,35,3,43,11,51,19,59,27,34,2,42,10,50,18,58,26,33,1,41,9,49,17,57,25"


1   ' Start Program

    ' Banner
    GOSUB 5

    ' Assign
    MESSAGE$ = ARGV$(2)
    KEY$     = ARGV$(4)

    ' Display Help
    IF ARGV$(1) = "-h" OR ARGV$(1) = "--help"    THEN GOTO 4
    IF ARGC% <> 5 THEN GOTO 3
    IF ARGV$(1) = "-e" OR ARGV$(1) = "--encrypt" THEN GOTO 13
    IF ARGV$(1) = "-d" OR ARGV$(1) = "--decrypt" THEN GOTO 19
    ' No key flag check O-o???


3   ' Help
    & "usage: des -h | -d | -e | -k"
    & "usage: des -e <string> -k <key>"
    & "usage: des -d <string> -k <key>"
    & "usage: des -e "CHR$(34)"I love Encryption :)"CHR$(34)" -k sekretpasswd"
    & "usage: des -d e6156a19d9b58fdfa898a2ba78b810fa -k 6FE543F991EE4911"
    END


4   ' Help extended
    & "DES - encrypt or decrypt a string":&
    & "usage: des -h | -d | -e | -k"
    & "usage: des -e <string> -k <key>"
    & "usage: des -d <string> -k <key>"
    & "usage: des -e "CHR$(34)"I love Encryption :)"CHR$(34)" -k sekretpasswd"
    & "usage: des -d e6156a19d9b58fdfa898a2ba78b810fa -k 6FE543F991EE4911":&
    & " This program follows the Data Encryption Standard."
    & "  It uses the ECB method (no salt), using a key"
    & "  length of 8 chars (64 bits). If the key passed"
    & "  is less than 8 chars it will be padded with `A`,"
    & "  longer, then it will be truncated. You may pass"
    & "  Hexadecimal as the key but the length then must"
    & "  be that of 16 (4 bits per digit, 64 bits).":&
    & " You can use this program by passing an unecrypted"
    & "  or encrypted string as a parameter with the"
    & "  flag `-e` or `-d`. If the string length isn't"
    & "  a multiple of 8 it will be padded with `+` until"
    & "  that threshold is met.":&
    & " Please note: the longer the string the longer"
    & "  the processing time will be.":&
    & "Options:"
    & "  -d, --decrypt" TAB(7) "Decrypt string"
    & "  -e, --encrypt" TAB(7) "Encrypt string"
    & "  -h, --help"   TAB(10) "display help message and exit"
    & "  -k, --key"    TAB(11) "Key used for encrypting/decrypting":&:&
    END

5   ' Banner
    & "/*"
    & " * $Id: DES v1.00 28255 Fr Jan 06 02:39:33 EDT 2023 ihaveroot $"
    & " */":&
RETURN


6   ' Check valid key
    & "[" Y$ "+" W$ "] Checking key length."

    ' Decryption redirect sometimes yields len warning
    IF KEYPAIR$(16) <> "" THEN RETURN

    ' If key passed is in hexadecimal then convert to binary, length must be 16 (4 bits per hex)
    IF TH_RE(KEY$, "^[0-9a-fA-F]{16}$", 1) THEN GOSUB 9

    ' After hexa2dec conversion, we do a binary len check, then create our subkeys
    IF TH_RE(KEYBIN$, "^[01]{64}$", 1) THEN GOSUB 12 : RETURN

    IF LEN(KEY$) < 8 THEN & Y$ + "Warning" + W$ + ": Key must be 8 chars (64 bits), padding key."    : GOSUB 7
    IF LEN(KEY$) > 8 THEN & Y$ + "Warning" + W$ + ": Key must be 8 chars (64 bits), truncating key." : GOSUB 8

    ' Create 16 Subkeys if key is string
    GOSUB 11
RETURN
7   ' Pad key
    KEY$ = KEY$ + STRING$(8 - LEN(KEY$), "A")
RETURN
8   ' Truncate key
    KEY$ = LEFT$(KEY$, 8)
RETURN
9  ' Hex to Binary -idk a better way to do this without a table.
    FOR I = 1 TO 16
        ' If string is a Decimal then convert to binary
        IF TH_RE(MID$(KEY$, I, 1), "\d", 1) THEN KEYBIN$ = KEYBIN$ + TH_SPRINTF$("%04b", MID$(KEY$, I, 1))
        ' If not then convert to Decimal
        IF TH_RE(MID$(KEY$, I, 1), "\D", 1) THEN GOSUB 10
    NEXT I
RETURN
10 ' Get Alphabetical Hexadecimal character to its decimal value
    FOR J = 10 TO 15
        IF MID$(KEY$, I, 1) = HEX$(J) THEN KEYBIN$ = KEYBIN$ + TH_SPRINTF$("%04b", J)
    NEXT J
RETURN


11  ' If key isn't in hexadecimal then convert to binary
    ' 8 bits per character 64bits total
    FOR I = 1 to 8
        KEYBIN$ = KEYBIN$ + TH_SPRINTF$("%08b", ASC(MID$(KEY$, I, 1)))
    NEXT I
12  ' 16 subkey creation routine, output: 48 bits per subkey

    & "[" G$ "+" W$ "] Key ok."
    & "[" Y$ "+" W$ "] Creating Subkeys."

   ' Key permutation, key goes from 64 bits to 56 using PC-1 Table
    FOR I = 1 TO 56
        KEYPC1$ = KEYPC1$ + MID$(KEYBIN$, FNTRAVERSE$(PC1$, I), 1)
    NEXT I

    ' Split key into left and right parts, both 28 bits each, 
    '  and concatenate for first keypair
    C$(0) = LEFT$(KEYPC1$, 28)  ' Left
    D$(0) = RIGHT$(KEYPC1$, 28) ' Right
    KEYPAIR$(0) = C$(0) + D$(0)

    ' Rotate keys left per iteration number and concatenate
    FOR I = 1 TO 16
        C$(I) = FNROTATE$(C$(I - 1), -ABS(FNTRAVERSE$(KEYLEFTSHIFT$, I)))
        D$(I) = FNROTATE$(D$(I - 1), -ABS(FNTRAVERSE$(KEYLEFTSHIFT$, I)))
        KEYPAIRSROTATED$(I) = C$(I) + D$(I)
        ' We form the keys by the PC-2 permutation table,
        '  each pair has 56 bits, PC-2 only uses 48 of those bits
        ' In the decryption process the key positions are reversed.
        '  K(16) = K(1), K(15) = K(2), K(14) = K(3)...
        FOR J = 1 TO 48
            KEYPAIR$(I) = KEYPAIR$(I) + MID$(KEYPAIRSROTATED$(I), FNTRAVERSE$(PC2$, J), 1)
        NEXT J
    NEXT I
    & ESC$ "[1A[" G$ "+" W$ "] Subkeys created."
RETURN


13   ' Encryption routine

    ' Key len check and creation
    GOSUB 6

    ' Message must be a multiple of 8 (8,16,24,32,40,...)
    IF LEN(MESSAGE$) MOD 8 <> 0 THEN & Y$ "Warning" W$ ": Message length is not a multiple of 8, padding message."

    ' If someone goes crazy and passes message over 8 characters,
    '  and since DES is a block cipher, we need to get blocks for 
    '  the encryption process. 
    ' 8 characters per block, 64 bits.
    FOR I = 1 TO LEN(MESSAGE$) STEP 8
        NUMBLOCKS = NUMBLOCKS + 1
        MESSAGEBLOCK$(NUMBLOCKS) = MESSAGEBLOCK$(NUMBLOCKS) + MID$(MESSAGE$, I, 8)
        ' Pad block if it's less than 8 characters
        '  I figure that it'd be more unpausable to have a user have trailing +'s
        '  In the string that they pass through this program.
        '  You can change this, make sure to change the regex in the TH_SED 
        '  func in the Binary to Decimal routine (ln 17)
        IF LEN(MESSAGEBLOCK$(NUMBLOCKS)) MOD 8 <> 0 THEN MESSAGEBLOCK$(NUMBLOCKS) = MESSAGEBLOCK$(NUMBLOCKS) + STRING$(8 - LEN(MESSAGEBLOCK$(NUMBLOCKS)), "+")
    NEXT I

    ' Translate characters into binary
    '  8 characters cleartext, 64 bits binary.
    '  We do this for each block.
    FOR I = 1 TO NUMBLOCKS
        FOR J = 1 TO 8
            MBBIN$(I) = MBBIN$(I) + TH_SPRINTF$("%08b", ASC(MID$(MESSAGEBLOCK$(I), J, 1)))
        NEXT J
    NEXT I


14   & "[" Y$ "!" W$ "] Number of Blocks in message: " NUMBLOCKS
    ' We finally start the encryption process for each block
    '  -This function does the encryption process, though
    '  it also acts as the decryptor. The keys are in reverse order when
    '  decrypting, K(16) = K(1), K(15) = K(2), K(14) = K(3)...
    '  and takes the encrypted Hexadecimal message output as the input. 
    '  The function above translates the cleartext message into binary,
    '  though the output for the encrypted message is in Hexadecimal, 
    '  we simply use a seperate function to go from Hexadecimal to binary
    '  for the message. We still need to get the amount of blocks for 
    '  the message, though instead of counting the characters (8 in a block)
    '  as above, we count the binary bits (64 in a block). This is done
    '  in the Decryption routine.
    & "[" G$ "O" W$ "] Starting Encryption/Decryption Routine."
    FOR I = 1 TO NUMBLOCKS
        & "[" Y$ "+" W$ "] Working on Block: " I : &
        ' Initial Permutation using the IP table
        FOR J = 1 TO 64
            MESSAGEBLOCKIP$(I) = MESSAGEBLOCKIP$(I) + MID$(MBBIN$(I), FNTRAVERSE$(IP$, J), 1)
        NEXT J
        ' Split the 64 bit block into 32 bits, leftside and rightside
        L$(0) = LEFT$(MESSAGEBLOCKIP$(I), 32)
        R$(0) = RIGHT$(MESSAGEBLOCKIP$(I), 32)
        ' The algorithm is as follows:
        '  Key(n)
        '  Left_Block(n)  = Right_Block(n-1)
        '  Right_block(n) = Left_Block(n-1) + f(Right_Block(n-1), Key(n))
        ' Where + denotes XOR operation bit by bit.
        ' In the function f we expand the Right block from 32 bits to 48 with the E BIT-Selection Table.
        '  Where the output will yield 48 bits, we then XOR with our Key. We group those bits by 6 as 
        '  input, and they go through the Subtitution boxes, yielding an output of 4 bits.
        ' The first and last bit in the 6 bit input will be our column reference, and the middle 4 bits
        '  will constitute our row for the lookup process in our substitution boxes.
        ' Given the bytes: 101011
        '  1xxxx1 is our column
        '  x0101x is our row
        ' For this example using the first Substitution Box we get an output of 9, where 11 is the 
        '  4th array in SBOX$ and 0101 is the 6th number in that array string.
        ' We do this process 16 times in each message block.
        FOR Z = 1 TO 16
            & ESC$ "[1A[" Y$ "+" W$ "] Encryption/Decryption round: " Z "/ 16"
            ' Starting with the E BIT-Selection Table to expand the Right_Block then XOR with our Key
            '  to get 8 groups of 6 bits each:
            '  Kn + E(R(n)) = B1,B2,B3,B4,B5,B6,B7,B8
            FOR K = 1 TO 48
                ' This simultaneously looks up the expansion bit from the E BIT-Selection table
                '  for the corresponding Right_Block, and does the XOR operation with the key.
                KER$ = KER$ + FNXOR$(KEYPAIR$(Z), R$(Z - 1), EBIT$, K)
            NEXT K
            ' 8 groups of 6 bits, 48 bits, in the expanded E BIT key
            ' The subtitution boxes are applied to the numerical group 
            '  order of the bits, where Sn is the substitution box being
            '  applied to Bn (the 6 bit group) in the expanded key:
            '  Kn + E(R(n)) = S1(B1)S2(B2)S3(B3)S4(B4)S5(B5)S6(B6)S7(B7)S8(B8)
            FOR L = 1 TO 48 STEP 6
            ' Get the group of bits in the expanded E BIT key
            GETBITGROUP$ = MID$(KER$, L, 6)
                ' We get the Row and Column
                FOR M = 1 TO 16
                    IF MID$(GETBITGROUP$, 2, 4) = FNTRAVERSE$(STABLEROW$, M) THEN ROW = M
                NEXT M
                FOR M = 1 TO 4
                    IF LEFT$(GETBITGROUP$, 1) + RIGHT$(GETBITGROUP$, 1) = FNTRAVERSE$(STABLECOLUMN$, M) THEN COLUMN = M
                NEXT M
                ' We keep track of which Substitution box to use for the
                '  related bit group position in our expanded key.
                SBOXCOUNT = SBOXCOUNT + 1
                ' Substitution boxes, arrays 1-4 represent the columns in the SBox, 
                '  while the strings in the arrays are the rows
                FOR M = 0 TO 3
                    IF COLUMN = M + 1 THEN SUBBIT$ = SUBBIT$ + TH_SPRINTF$("%06b", FNTRAVERSE$(SBOX$(INT(FNTRAVERSE$(SBOXARRAY$, SBOXCOUNT)) + M), ROW))
                NEXT M
            NEXT L
            ' We apply a final permutation of the subbed bits 
            '  with the P table to yield a 32 bit output.
            ' This will complete the function of f in our formula:
            '  f(Right_Block(n-1), Key(n))
            FOR L = 1 TO 32
                FINALPERM$ = FINALPERM$ + MID$(SUBBIT$, FNTRAVERSE$(P$, L), 1)
            NEXT L
            ' Left_Block(n) equals our Right_Block(n-1)
            L$(Z) = R$(Z - 1)

            ' We then XOR with our Left_Block(n-1),
            ' which will be our final output for Right_Block(n)
            ' Right_Block(n) = Left_Block(n-1) + f(Right_Block(n-1), Key(n))
            FOR L = 1 TO 32
                R$(Z) = R$(Z) + FNXORLKER$(L$(Z - 1), FINALPERM$, L)
            NEXT L

            ' We do 16 rounds of encryption, we reset some of the variables
            SBOXCOUNT = 0
            KER$ = ""
            SUBBIT$ = ""
            FINALPERM$ = ""
        ' We go back and do this process 16 times
        NEXT Z

        & ESC$ "[1A" SPA(45)

        ' We have our encrypted Message, and we
        '  reverse the Left and Right blocks to apply the IP^-1 Table
        '  to get our final encrypted message 64 bits long.
        REVERSEDBLOCKS$ = R$(16) + L$(16)
        FOR Z = 1 TO 64
            IP1PERMUTATION$ = IP1PERMUTATION$ + MID$(REVERSEDBLOCKS$, FNTRAVERSE$(IP1$, Z), 1)
        NEXT Z

        ' If we've chosen to encrypt then we do Binary to Hexadecimal Conversion
        '  and store that in our Encrypted Message variable
        IF ARGV$(1) = "-e" OR ARGV$(1) = "--encrypt" THEN GOSUB 15

        ' Alternatively if we are decrypting then we do Binary to Decimal Conversion
        IF ARGV$(1) = "-d" OR ARGV$(1) = "--decrypt" THEN GOSUB 17

        ' Clear var for the next block
        IP1PERMUTATION$ = ""
        FOR Z = 0 TO 16
            R$(Z) = "" : L$(Z) = ""
        NEXT Z

        & ESC$ "[2A[" G$ "+" W$ "] Block: " (I) " Completed."

    ' If there is another block then return to encrypt the second block
    NEXT I

    ' Output Results if we are finished the Encryption/Decryption routine
    GOTO 100


15  ' BIN2HEX Conversion
    FOR Z = 1 TO 64 STEP 32
        FOR A = 1 TO 32
            IF MID$(MID$(IP1PERMUTATION$, Z, 32), A, 1) = "1" THEN BIN2HEX = BIN2HEX + (2**(32 - A))
        NEXT A
        
16      ENCMBUFFER$ = HEX$(STR$(BIN2HEX MOD 16)) + ENCMBUFFER$
        BIN2HEX = INT(BIN2HEX / 16)
        IF BIN2HEX > 0 THEN GOTO 16

        ' Sometimes the operation above will skip if BIN2HEX is 
        '  a decimal less than 1 but greater than 0 (ex. 0.25)
        '  so we insert a 0 if the length isn't 8 digits.
        '  Works out fine in decrypting :>
        IF LEN(ENCMBUFFER$) < 8 THEN ENCMBUFFER$ = "0" + ENCMBUFFER$
        ' Add the Hexadecimal buffer to our message
        ENCMESSAGE$ = ENCMESSAGE$ + ENCMBUFFER$
        ENCMBUFFER$ = ""
    NEXT Z
    BIN2HEX = 0
RETURN


17  ' BIN2DEC Conversion
    FOR G = 1 to LEN(IP1PERMUTATION$) STEP 8
        FOR K = 1 TO 8
            IF MID$(MID$(IP1PERMUTATION$, G, 8), K, 1) = "1" THEN BIN2DEC = BIN2DEC + (2 ** (8 - K))
        NEXT K

    ' Add the decrypted character to our message
    ENCMESSAGE$ = ENCMESSAGE$ + CHR$(BIN2DEC)
    BIN2DEC = 0
    NEXT G
    ' Sed out our padding if any.
    ENCMESSAGE$ = TH_SED$(ENCMESSAGE$, "\++$", "", "gi")
RETURN


19  ' Decryption routine

    ' Key len check and creation
    GOSUB 6

    ' Keys are in reversed order in decryption process.
    '  Too lazy to incorporate it in the key creation func
    FOR I = 1 TO 16
        KEYBUFFER$(I) = KEYPAIR$(I)
    NEXT I
    FOR I = 1 TO 16
        KEYPAIR$(I) = KEYBUFFER$(17 - I)
    NEXT I

    ' We do a check because this program outputs a len group of 16 in hexadecimal.
    '  If it is not a multiple of 16 then we treat it as a regular string
    '  and redirect to encryption routine. Can be annoying, you can change it with END
    IF LEN(MESSAGE$) MOD 16 <> 0 THEN & Y$ "Warning" W$ ": Encrypted Message length is not a multiple of 16, Check your input."
    IF LEN(MESSAGE$) MOD 16 <> 0 THEN & Y$ "Warning" W$ ": Running in Encryption Mode." : ARGV$(1) = "-e" : GOTO 13

    ' Hex2bin conversion
    GOSUB 20

    ' Unlike the encryption routine, we get the blocks per 64 bits,
    '  rather than every 8 characters. This is the same loop in the
    '  encryption routine but we don't include a check for padding.
    FOR I = 1 TO LEN(MESSBIN$) STEP 64
        NUMBLOCKS = NUMBLOCKS + 1
        MBBIN$(NUMBLOCKS) = MBBIN$(NUMBLOCKS) + MID$(MESSBIN$, I, 64)
    NEXT I

    ' Start decryption process.
    ' It's entirely the same formula
    GOTO 14

20  ' Hex to Binary
    '  This is the same as the Hexadecimal key conversion (ln 9) but
    '  modified to parse the encrypted input string.
      FOR I = 1 TO LEN(MESSAGE$)
          ' If string is a Decimal then convert to binary
          IF TH_RE(MID$(MESSAGE$, I, 1), "\d", 1) THEN MESSBIN$ = MESSBIN$ + TH_SPRINTF$("%04b", MID$(MESSAGE$, I, 1))
          ' If not then convert to Decimal
          IF TH_RE(MID$(MESSAGE$, I, 1), "\D", 1) THEN GOSUB 21
      NEXT I
RETURN
21  ' Get Alphabetical Hexadecimal character to its decimal value
    FOR J = 10 TO 15
        IF MID$(MESSAGE$, I, 1) = HEX$(J) THEN MESSBIN$ = MESSBIN$ + TH_SPRINTF$("%04b", J)
    NEXT J
RETURN


100 ' Our Encryption/Decryption Process is complete,
    '  we output to the user the configs.
    &
    & TAB(5) "Args Passed:"
    & TAB(5) "================================"
    & TAB(5) "-INPUT:   " ARGV$(2)
    & TAB(5) "-KEY:     " ARGV$(4) : &
    IF LEN(ARGV$(4)) <> 8 AND LEN(ARGV$(4)) <> 16 THEN & TAB(5) "-KEY USED: " Y$ KEY$ W$ : &
    & TAB(5) "-MESSAGE: " Y$ ENCMESSAGE$ W$
    &
    & TAB(5) Y$ "Warning" W$ ": Make sure that you take note of the key used and store it"
    & TAB(9) "in a safe place. Without it, the contents of your message will be gone forever!":&:&:&


    ' :)
    END
