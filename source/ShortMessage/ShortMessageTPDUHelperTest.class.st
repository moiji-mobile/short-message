Class {
	#name : #ShortMessageTPDUHelperTest,
	#superclass : #TestCase,
	#category : #'ShortMessage-Tests'
}

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testExtractDeliver [
	| inp extracted |
	inp := #[4 11 145 51 102 2 19 69 244 0 0 65 112 113 129 4 113 128 6 210 114 185 92 70 3].
	extracted := ShortMessageTPDUHelper extract: inp.
	self assert: (extracted at: 'TP-RP') equals: false.
	self assert: (extracted at: 'TP-UDHI') equals: false.
	self assert: (extracted at: 'TP-SRI') equals: false.
	self deny: (extracted at: 'TP-MMS').
	self assert: (extracted at: 'TP-MTI') equals: 0.

	self assert: (extracted at: 'npi') equals: 1.
	self assert: (extracted at: 'ton') equals: 1.
	self assert: (extracted at: 'TP-OA') equals: '33662031544'.
	self assert: (extracted at: 'TP-DCS') equals: 0.
	self assert: (extracted at: 'TP-SCTS') equals: #[16r41 16r70 16r71 16r81 16r04 16r71 16r80].
	self assert: (extracted at: 'TP-UD') equals: #[16rD2 16r72 16rB9 16r5C 16r46 16r03].
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testExtractDeliverEvenNumber [
	| inp extracted |
	inp := ByteArray readHexFrom: '240c9153345800109100004170031102950012d4f29c0e32cbdf6dd0d3ddba87ede539'.
	extracted := ShortMessageTPDUHelper extract: inp.
	self assert: (extracted at: 'TP-RP') equals: false.
	self assert: (extracted at: 'TP-UDHI') equals: false.
	self assert: (extracted at: 'TP-SRI') equals: true.
	self deny: (extracted at: 'TP-MMS').
	self assert: (extracted at: 'TP-MTI') equals: 0.

	self assert: (extracted at: 'npi') equals: 1.
	self assert: (extracted at: 'ton') equals: 1.
	self assert: (extracted at: 'TP-OA') equals: '354385000119'.
	self assert: (extracted at: 'TP-DCS') equals: 0.
	self assert: (extracted at: 'TP-SCTS') equals: #[65 112 3 17 2 149 0].
	self assert: (extracted at: 'TP-UD') equals: #[212 242 156 14 50 203 223 109 208 211 221 186 135 237 229 57].
	self assert: (extracted at: 'TP-UD-Len') equals: 18.
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testExtractDeliverUDHHeader [
	| inp extracted |
	inp := ByteArray readHexFrom: '640c91533458001091000041804031016000a0050003d90201a2f7b29c9eafa7dff0f9dc4c3e9fd16b36dbed1ee3f1ee76fbbd76bb586490596606e1f178d07c8e06a5f3f5b39a9c4e9fcfe4b4fa8c9ed7d3e8391a9d9ea36b38994c60328546bdd56fb74ba1509bb2aab4416d521bdec6a776bb91c8a9326bb41685cae55469b54e914ae554683d56a7caa91269454e975aa5f5383d2aa74aab70aa9c2e85'.
	extracted := ShortMessageTPDUHelper extract: inp.
	self assert: (extracted at: 'TP-RP') equals: false.
	self assert: (extracted at: 'TP-UDHI') equals: true.
	self assert: (extracted at: 'TP-SRI') equals: true.
	self deny: (extracted at: 'TP-MMS').
	self assert: (extracted at: 'TP-MTI') equals: 0.

	self assert: (extracted at: 'npi') equals: 1.
	self assert: (extracted at: 'ton') equals: 1.
	self assert: (extracted at: 'TP-OA') equals: '354385000119'.
	self assert: (extracted at: 'TP-DCS') equals: 0.
	self assert: (extracted at: 'TP-SCTS') equals: #[65 128 64 49 1 96 0].
	self assert: (extracted at: 'TP-UDH') equals: #[0 3 217 2 1 ].
	self assert: (extracted at: 'TP-UD') equals: #[162 247 178 156 158 175 167 223 240 249 220 76 62 159 209 107 54 219 237 30 227 241 238 118 251 189 118 187 88 100 144 89 102 6 225 241 120 208 124 142 6 165 243 245 179 154 156 78 159 207 228 180 250 140 158 215 211 232 57 26 157 158 163 107 56 153 76 96 50 133 70 189 213 111 183 75 161 80 155 178 170 180 65 109 82 27 222 198 167 118 187 145 200 169 50 107 180 22 133 202 229 84 105 181 78 145 74 229 84 104 61 86 167 202 169 18 105 69 78 151 90 165 245 56 61 42 167 74 171 112 170 156 46 133].
	self assert: (extracted at: 'TP-UD-Len') equals: 160.
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testExtractOddAlphanumeric [
	| extracted |
	extracted := ShortMessageTPDUHelper extract: #[4 9 208 243 117 30 94 6 0 0 81 112 32 33 149 101 0 31 237 48 157 158 14 207 217 117 55 121 78 151 191 203 109 157 130 90 158 211 65 205 48 157 158 14 207 1].

	self assert: (extracted at: 'npi') equals: 0.
	self assert: (extracted at: 'ton') equals: 5.
	self assert: (extracted at: 'TP-OA') equals: 'skype'.

]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testExtractSubmit [
	| inp extracted |
	inp := #[1 12 15 129 0 148 81 135 134 120 70 245 0 0 9 204 183 189 12 202 191 235 32].
	extracted := ShortMessageTPDUHelper extract: inp.
	self assert: (extracted at: 'TP-RP') equals: false.
	self assert: (extracted at: 'TP-UDHI') equals: false.
	self assert: (extracted at: 'TP-SRR') equals: false.
	self assert: (extracted at: 'TP-VPFI') equals: 0.
	self assert: (extracted at: 'TP-RD') equals: true.
	self assert: (extracted at: 'TP-MTI') equals: 1.
	self assert: (extracted at: 'TP-MR') equals: 12.

	self assert: (extracted at: 'npi') equals: 1.
	self assert: (extracted at: 'ton') equals: 0.
	self assert: (extracted at: 'TP-DA') equals: '004915786887645'.
	self assert: (extracted at: 'TP-DCS') equals: 0.
	self assert: (extracted at: 'TP-UD') equals: #[204 183 189 12 202 191 235 32].
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testExtractSubmitVP [
	| inp extracted |
	inp := #[17 116 12 145 54 41 57 133 2 112 0 0 173 158 206 112 158 69 150 151 65 114 56 59 15 66 135 65 235 60 40 220 126 131 220 105 144 251 237 2 173 223 32 117 221 158 30 187 64 232 182 152 29 6 141 65 236 48 59 156 118 151 65 110 16 29 15 154 175 221 160 245 25 180 110 207 233 97 80 216 253 6 137 195 236 52 61 12 162 135 221 97 183 12 15 34 135 65 240 48 61 13 154 131 218 231 48 168 78 127 147 65 235 55 104 125 6 181 207 97 80 59 236 126 175 65 235 51 104 14 130 135 217 105 241 155 238 2 189 215 32 246 25 180 126 147 211 46 16 29 47 94 3].
	extracted := ShortMessageTPDUHelper extract: inp.
	self assert: (extracted at: 'TP-RP') equals: false.
	self assert: (extracted at: 'TP-UDHI') equals: false.
	self assert: (extracted at: 'TP-SRR') equals: false.
	self assert: (extracted at: 'TP-VPFI') equals: 2.
	self assert: (extracted at: 'TP-RD') equals: true.
	self assert: (extracted at: 'TP-MTI') equals: 1.
	self assert: (extracted at: 'TP-MR') equals: 116.

	self assert: (extracted at: 'npi') equals: 1.
	self assert: (extracted at: 'ton') equals: 1.
	self assert: (extracted at: 'TP-DA') equals: '639293582007'.
	self assert: (extracted at: 'TP-DCS') equals: 0.
	self assert: (extracted at: 'TP-VP') equals: #[16rAD].
	self assert: (extracted at: 'TP-UD') equals: #[206 112 158 69 150 151 65 114 56 59 15 66 135 65 235 60 40 220 126 131 220 105 144 251 237 2 173 223 32 117 221 158 30 187 64 232 182 152 29 6 141 65 236 48 59 156 118 151 65 110 16 29 15 154 175 221 160 245 25 180 110 207 233 97 80 216 253 6 137 195 236 52 61 12 162 135 221 97 183 12 15 34 135 65 240 48 61 13 154 131 218 231 48 168 78 127 147 65 235 55 104 125 6 181 207 97 80 59 236 126 175 65 235 51 104 14 130 135 217 105 241 155 238 2 189 215 32 246 25 180 126 147 211 46 16 29 47 94 3].
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testProtocolIdRoundTripSMPP [
	| smpp extracted |

	"Begin with a deliver"
 	smpp := SMPPMessage readFrom: #[0 0 0 196 0 0 0 5 0 0 0 0 2 125 0 0 0 1 1 51 53 52 51 56 53 49 48 48 49 55 48 0 1 1 52 54 55 48 50 57 57 53 52 48 52 0 64 2 1 0 0 0 0 8 0 140 5 0 3 19 2 1 0 39 150 63 87 250 145 204 101 175 103 44 103 101 92 49 102 47 85 74 84 64 94 114 86 27 84 64 79 96 139 244 98 17 102 47 78 13 102 47 98 17 78 95 137 129 119 97 84 39 79 96 78 236 79 233 91 87 101 112 99 110 126 191 78 134 85 74 84 200 84 200 89 39 123 17 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200] readStream.
	self assert: smpp body protocolId equals: 2.
	extracted := smpp body toDeliverTPDUDictionary.
	self assert: (extracted at: 'TP-PID') equals: 2.

	"SubmitSM now"
	smpp := SMPPMessage readFrom: #[0 0 0 220 0 0 0 4 0 0 0 0 72 4 0 0 0 1 1 51 53 52 51 56 53 49 48 48 49 55 48 0 1 1 51 53 52 56 54 52 57 52 51 55 0 64 3 1 0 0 1 0 0 0 159 5 0 3 253 2 1 113 119 101 114 116 121 117 105 111 112 97 115 100 102 103 104 106 107 108 122 120 99 118 98 110 109 113 119 101 114 116 121 117 105 111 112 97 115 100 102 103 104 106 107 108 122 120 99 118 98 110 109 10 113 119 101 114 116 121 117 105 111 112 97 115 100 102 103 104 106 107 108 122 120 99 118 98 110 109 113 119 101 114 116 121 117 105 111 112 97 115 100 102 103 104 106 107 108 122 120 99 118 98 110 109 10 113 119 101 114 116 121 117 105 111 112 97 115 100 102 103 104 106 107 108 122 120 99 118 98 110 109 113 119 101 114 116 121 117 105 111 112 97 115 100 102 103 104 106 107 108 122 120 2 4 0 2 202 0] readStream.
	self assert: smpp body protocolId equals: 3.
	extracted := smpp body toSubmitTPDUDictionary.
	self assert: (extracted at: 'TP-PID') equals: 3.
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testProtocolIdRoundTripSMS [
	| inp extracted out |

	"Begin with a deliver"
 	inp := #[4 11 145 51 102 2 19 69 244 1 0 65 112 113 129 4 113 128 6 210 114 185 92 70 3].
	extracted := ShortMessageTPDUHelper extract: inp.
	self assert: (extracted at: 'TP-PID') equals: 1.
	out := ShortMessageTPDUHelper encodeDeliver: extracted.
	self assert: out equals: inp.

	inp :=  #[1 12 15 129 0 148 81 135 134 120 70 245 1 0 9 204 183 189 12 202 191 235 32].
	extracted := ShortMessageTPDUHelper extract: inp.
	self assert: (extracted at: 'TP-PID') equals: 1.
	out := ShortMessageTPDUHelper encodeSubmit: extracted.
	self assert: out equals: inp.
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testRoundTripDeliver: anInput [
	| extracted encoded |
	extracted := ShortMessageTPDUHelper extract: anInput.
	encoded := ShortMessageTPDUHelper encodeDeliver: extracted.
	self assert: encoded equals: anInput.
	
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testRoundTripSubmit: anInput [
	| extracted encoded |
	extracted := ShortMessageTPDUHelper extract: anInput.
	encoded := ShortMessageTPDUHelper encodeSubmit: extracted.
	self assert: encoded equals: anInput.
	
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testRoundtripExtractDeliver [
	self testRoundTripDeliver: #[4 11 145 51 102 2 19 69 244 0 0 65 112 113 129 4 113 128 6 210 114 185 92 70 3].

	"With UDH.."
	self testRoundTripDeliver: #[100 12 145 83 52 88 0 16 145 0 0 65 128 64 49 1 96 0 160 5 0 3 217 2 1 162 247 178 156 158 175 167 223 240 249 220 76 62 159 209 107 54 219 237 30 227 241 238 118 251 189 118 187 88 100 144 89 102 6 225 241 120 208 124 142 6 165 243 245 179 154 156 78 159 207 228 180 250 140 158 215 211 232 57 26 157 158 163 107 56 153 76 96 50 133 70 189 213 111 183 75 161 80 155 178 170 180 65 109 82 27 222 198 167 118 187 145 200 169 50 107 180 22 133 202 229 84 105 181 78 145 74 229 84 104 61 86 167 202 169 18 105 69 78 151 90 165 245 56 61 42 167 74 171 112 170 156 46 133].
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testRoundtripExtractSubmit [
	self testRoundTripSubmit: #[1 12 15 129 0 148 81 135 134 120 70 245 0 0 9 204 183 189 12 202 191 235 32].
	self testRoundTripSubmit: #[17 116 12 145 54 41 57 133 2 112 0 0 173 158 206 112 158 69 150 151 65 114 56 59 15 66 135 65 235 60 40 220 126 131 220 105 144 251 237 2 173 223 32 117 221 158 30 187 64 232 182 152 29 6 141 65 236 48 59 156 118 151 65 110 16 29 15 154 175 221 160 245 25 180 110 207 233 97 80 216 253 6 137 195 236 52 61 12 162 135 221 97 183 12 15 34 135 65 240 48 61 13 154 131 218 231 48 168 78 127 147 65 235 55 104 125 6 181 207 97 80 59 236 126 175 65 235 51 104 14 130 135 217 105 241 155 238 2 189 215 32 246 25 180 126 147 211 46 16 29 47 94 3].
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testRoundtripUDH [
	| inpDict smppMessage resDict |
	inpDict := Dictionary new
		at: 'TP-UD' put: #[226 247 178 156 158 175 167 223 240 95 120 78 54 159 209 234 53 251 247 211 227 199 118 177 187 29 189 22 165 212 108 53 249 132 254 130 83 162 241 136 84 46 153 191 159 22 59 180 10 157 205 152 108 70 171 217 110 184 28 44 126 47 203 233 249 122 250 13 255 133 231 100 243 25 173 94 179 127 63 61 126 108 23 187 219 49 217 140 86 179 221 112 57 88 244 90 148 82 179 213 228 19 250 11 78 137 198 35 82 185 100 254 126 90 236 208 42 116 54 99 178 25 173 102 187 225 114 176 248 189 44 167 231 235];
		at: 'TP-UD-Len' put: 160;
		at: 'TP-UDHI' put: true;
		at: 'TP-UDH' put: #[0 3 168 2 1];
		yourself.

	smppMessage := SMPPDeliverSM new.
	ShortMessageTPDUHelper formatFromGSM7Bit: inpDict on: smppMessage.

	resDict := Dictionary new.
	ShortMessageTPDUHelper formatToGSM7Bit: resDict on: smppMessage.

	self assert: (resDict at: 'TP-UDHI') equals: (inpDict at: 'TP-UDHI').
	self assert: (resDict at: 'TP-UDH') equals: (inpDict at: 'TP-UDH').
	self assert: (resDict at: 'TP-UD-Len') equals: (inpDict at: 'TP-UD-Len').
	self assert: (resDict at: 'TP-UD') equals: (inpDict at: 'TP-UD').


	"Try again with a SubmitSM.."
	smppMessage := SMPPSubmitSM new.
	ShortMessageTPDUHelper formatFromGSM7Bit: inpDict on: smppMessage.

	resDict := Dictionary new.
	ShortMessageTPDUHelper formatToGSM7Bit: resDict on: smppMessage.

	self assert: (resDict at: 'TP-UDHI') equals: (inpDict at: 'TP-UDHI').
	self assert: (resDict at: 'TP-UDH') equals: (inpDict at: 'TP-UDH').
	self assert: (resDict at: 'TP-UD-Len') equals: (inpDict at: 'TP-UD-Len').
	self assert: (resDict at: 'TP-UD') equals: (inpDict at: 'TP-UD').
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testSMPPDeliverUDHUCS2Extract [
	| smpp extracted  res decodedSMS |
	smpp := SMPPMessage readFrom: #[0 0 0 196 0 0 0 5 0 0 0 0 2 125 0 0 0 1 1 51 53 52 51 56 53 49 48 48 49 55 48 0 1 1 52 54 55 48 50 57 57 53 52 48 52 0 64 0 1 0 0 0 0 8 0 140 5 0 3 19 2 1 0 39 150 63 87 250 145 204 101 175 103 44 103 101 92 49 102 47 85 74 84 64 94 114 86 27 84 64 79 96 139 244 98 17 102 47 78 13 102 47 98 17 78 95 137 129 119 97 84 39 79 96 78 236 79 233 91 87 101 112 99 110 126 191 78 134 85 74 84 200 84 200 89 39 123 17 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200] readStream.

	extracted := smpp body toDeliverTPDUDictionary.
	self assert: (extracted at: 'TP-UDHI').
	self assert: (extracted at: 'TP-UDH') equals: #[0 3 19 2 1].
	self assert: (extracted at: 'TP-DCS') equals: 8.
	self assert: (extracted at: 'TP-UD-Len') equals: 140.
	self assert: (extracted at: 'TP-UD') equals: #[0 39 150 63 87 250 145 204 101 175 103 44 103 101 92 49 102 47 85 74 84 64 94 114 86 27 84 64 79 96 139 244 98 17 102 47 78 13 102 47 98 17 78 95 137 129 119 97 84 39 79 96 78 236 79 233 91 87 101 112 99 110 126 191 78 134 85 74 84 200 84 200 89 39 123 17 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200].

	res := ShortMessageTPDUHelper encodeDeliver: extracted.

	decodedSMS := ShortMessageTPDUHelper extract: res.
	self assert: (decodedSMS at: 'TP-UD') equals: #[0 39 150 63 87 250 145 204 101 175 103 44 103 101 92 49 102 47 85 74 84 64 94 114 86 27 84 64 79 96 139 244 98 17 102 47 78 13 102 47 98 17 78 95 137 129 119 97 84 39 79 96 78 236 79 233 91 87 101 112 99 110 126 191 78 134 85 74 84 200 84 200 89 39 123 17 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200 84 200].
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testSMPPUDH7BitExtract [
	| smpp extracted |
	smpp := SMPPMessage readFrom: #[0 0 0 220 0 0 0 4 0 0 0 0 72 4 0 0 0 1 1 51 53 52 51 56 53 49 48 48 49 55 48 0 1 1 51 53 52 56 54 52 57 52 51 55 0 64 0 1 0 0 1 0 0 0 159 5 0 3 253 2 1 113 119 101 114 116 121 117 105 111 112 97 115 100 102 103 104 106 107 108 122 120 99 118 98 110 109 113 119 101 114 116 121 117 105 111 112 97 115 100 102 103 104 106 107 108 122 120 99 118 98 110 109 10 113 119 101 114 116 121 117 105 111 112 97 115 100 102 103 104 106 107 108 122 120 99 118 98 110 109 113 119 101 114 116 121 117 105 111 112 97 115 100 102 103 104 106 107 108 122 120 99 118 98 110 109 10 113 119 101 114 116 121 117 105 111 112 97 115 100 102 103 104 106 107 108 122 120 99 118 98 110 109 113 119 101 114 116 121 117 105 111 112 97 115 100 102 103 104 106 107 108 122 120 2 4 0 2 202 0] readStream.

	extracted := smpp body toSubmitTPDUDictionary.
	self assert: (extracted at: 'TP-UDHI').
	self assert: (extracted at: 'TP-UDH') equals: #[0 3 253 2 1].
	self assert: (extracted at: 'TP-DCS') equals: 0.
	self assert: (extracted at: 'TP-UD-Len') equals: 160.
	self assert: (extracted at: 'TP-UD') equals: #[226 247 178 156 158 175 167 223 240 240 156 108 62 163 213 107 182 30 63 182 139 221 237 248 189 44 167 231 235 233 55 60 60 39 155 207 104 245 154 173 199 143 237 98 119 91 17 191 151 229 244 124 61 253 134 135 231 100 243 25 173 94 179 245 248 177 93 236 110 199 239 101 57 61 95 79 191 225 225 57 217 124 70 171 215 108 61 126 108 23 187 219 138 248 189 44 167 231 235 233 55 60 60 39 155 207 104 245 154 173 199 143 237 98 119 59 126 47 203 233 249 122 250 13 15 207 201 230 51 90 189 102 235 241].
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testSMPPUDHUCS2Extract [
	| smpp extracted |
	smpp := SMPPMessage readFrom: #[0 0 0 202 0 0 0 4 0 0 0 0 174 2 0 0 0 1 1 51 53 52 51 56 53 49 48 48 49 55 48 0 1 1 52 54 55 48 50 57 57 53 52 48 52 0 64 0 1 0 0 0 0 8 0 140 5 0 3 249 3 1 0 64 0 163 0 36 0 165 0 232 0 233 0 249 0 236 0 242 0 199 0 32 0 216 0 248 0 32 0 197 0 229 0 10 3 148 0 95 3 166 3 147 3 155 3 169 3 160 3 168 3 163 3 152 3 158 0 32 0 198 0 230 3 178 0 201 0 10 0 32 0 33 0 34 0 35 0 32 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 10 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63 2 4 0 2 171 0] readStream.

	extracted := smpp body toSubmitTPDUDictionary.
	self assert: (extracted at: 'TP-UDHI').
	self assert: (extracted at: 'TP-UDH') equals: #[0 3 16rF9 3 1].
	self assert: (extracted at: 'TP-DCS') equals: 8.
	self assert: (extracted at: 'TP-UD-Len') equals: 140.
	self assert: (extracted at: 'TP-UD') equals: #[0 64 0 163 0 36 0 165 0 232 0 233 0 249 0 236 0 242 0 199 0 32 0 216 0 248 0 32 0 197 0 229 0 10 3 148 0 95 3 166 3 147 3 155 3 169 3 160 3 168 3 163 3 152 3 158 0 32 0 198 0 230 3 178 0 201 0 10 0 32 0 33 0 34 0 35 0 32 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 10 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63].
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelperTest >> testSMPPUDHUCS2SMSEncode [
	| smpp extracted res decodedSMS |
	smpp := SMPPMessage readFrom: #[0 0 0 202 0 0 0 4 0 0 0 0 174 2 0 0 0 1 1 51 53 52 51 56 53 49 48 48 49 55 48 0 1 1 52 54 55 48 50 57 57 53 52 48 52 0 64 0 1 0 0 0 0 8 0 140 5 0 3 249 3 1 0 64 0 163 0 36 0 165 0 232 0 233 0 249 0 236 0 242 0 199 0 32 0 216 0 248 0 32 0 197 0 229 0 10 3 148 0 95 3 166 3 147 3 155 3 169 3 160 3 168 3 163 3 152 3 158 0 32 0 198 0 230 3 178 0 201 0 10 0 32 0 33 0 34 0 35 0 32 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 10 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63 2 4 0 2 171 0] readStream.

	extracted := smpp body toSubmitTPDUDictionary.
	self assert: (extracted at: 'TP-UDH') equals: #[0 3 16rF9 3 1].
	self assert: (extracted at: 'TP-UD-Len') equals: 140.
	res := ShortMessageTPDUHelper encodeSubmit: extracted.

	decodedSMS := ShortMessageTPDUHelper extract: res.
	self assert: (decodedSMS at: 'TP-UD') equals: #[0 64 0 163 0 36 0 165 0 232 0 233 0 249 0 236 0 242 0 199 0 32 0 216 0 248 0 32 0 197 0 229 0 10 3 148 0 95 3 166 3 147 3 155 3 169 3 160 3 168 3 163 3 152 3 158 0 32 0 198 0 230 3 178 0 201 0 10 0 32 0 33 0 34 0 35 0 32 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 10 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63].
]
