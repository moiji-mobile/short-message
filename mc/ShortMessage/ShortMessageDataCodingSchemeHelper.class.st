"
I help to bridge from SMS to SMPP DCS coding.

The relevant specs are:
	GSM 03.38
	SMPP v3.4
	smppv34_gsmumts_ig_v10
"
Class {
	#name : #ShortMessageDataCodingSchemeHelper,
	#superclass : #Object,
	#category : #'ShortMessage-Helper'
}

{ #category : #'as yet unclassified' }
ShortMessageDataCodingSchemeHelper class >> convertDataCoding: tpdu toDeliverSM: deliverSM [
	| dcs |

	deliverSM esmClass: 0.
	dcs := tpdu at: 'TP-DCS'.
	(dcs bitAnd: 2r100) = 0
		ifTrue: [
			ShortMessageTPDUHelper formatFromGSM7Bit: tpdu on: deliverSM.
			deliverSM dataCoding: dcs]
		ifFalse: [
			ShortMessageTPDUHelper formatFromOctets: tpdu on: deliverSM.
			deliverSM dataCoding: dcs].
	^true
]

{ #category : #'as yet unclassified' }
ShortMessageDataCodingSchemeHelper class >> convertFromSMPPDeliverSM: deliverSM toSMS: result [
	| dcs type |

	dcs := deliverSM dataCoding.
	dcs = 0 ifTrue: [
		result at: 'TP-DCS' put: 0.
		^ShortMessageTPDUHelper formatToGSM7Bit: result on: deliverSM].
	dcs = 1 ifTrue: [
		result at: 'TP-DCS' put: 2r0100.
		^ShortMessageTPDUHelper formatToOctets: result on: deliverSM].
	dcs = 2r1000 ifTrue: [
		result at: 'TP-DCS' put: 2r1000.
		^ShortMessageTPDUHelper formatToOctets: result on: deliverSM].

	"Message Waiting Indication"
	type := (dcs bitShift: -4) bitAnd: 2r1111.
	(#(2r1100 2r1101) includes: type) ifTrue: [
		| res |
		res := ShortMessageTPDUHelper formatToGSM7Bit: result on: deliverSM.
		result at: 'TP-DCS' put: dcs.
		^res].

	"Data Coding Message"
	type = 2r1111 ifTrue: [
		(dcs bitAnd: 2r100) = 0 ifTrue: [
			| res |
			res := ShortMessageTPDUHelper formatToGSM7Bit: result on: deliverSM.
			result at: 'TP-DCS' put: dcs.
			^res]].

	"Assume 1:1 mapping.."
	result at: 'TP-DCS' put: dcs.
	^ShortMessageTPDUHelper formatToOctets: result on: deliverSM.
]

{ #category : #'as yet unclassified' }
ShortMessageDataCodingSchemeHelper class >> convertFromSMPPSubmitSM: submitSM toSMS: result [
	"SubmitSM would be able to express more so let's fallback
	to a subset of what we could do"
	^self convertFromSMPPDeliverSM: submitSM toSMS: result.
]

{ #category : #'as yet unclassified' }
ShortMessageDataCodingSchemeHelper class >> convertGeneralCoding: tpdu toDeliverSM: deliverSM [ 
	| dcs |
	dcs := tpdu at: 'TP-DCS'.

	deliverSM esmClass: 0.
	
	"Compression is used?"
	(dcs bitAnd: 2r100000) > 0 ifTrue: [
		"Compression is not easily expressable? Skip it"
		^false].

	"Treat 7bit differently"
	(dcs bitAnd: 2r1100) = 2r0000 ifTrue: [
		ShortMessageTPDUHelper formatFromGSM7Bit: tpdu on: deliverSM].
	(dcs bitAnd: 2r1100) = 2r0100 ifTrue: [
		deliverSM dataCoding: 2r01.
		ShortMessageTPDUHelper formatFromOctets: tpdu on: deliverSM].
	(dcs bitAnd: 2r1100) = 2r1000 ifTrue: [
		deliverSM dataCoding: 2r1000.
		ShortMessageTPDUHelper formatFromOctets: tpdu on: deliverSM].
	(dcs bitAnd: 2r1100) = 2r1100 ifTrue: [
		"Reserved.."
		^false].

	"We can not map this to a SMPP DeliverSM"
	(dcs bitAnd: 2r10000) > 0 ifTrue: [
		^false].

	^true
]

{ #category : #'as yet unclassified' }
ShortMessageDataCodingSchemeHelper class >> convertMessageWaitingIndication: tpdu toDeliverSM: deliverSM ucs2: useUCS2 [
	| dcs |

	dcs := tpdu at: 'TP-DCS'.
	deliverSM esmClass: 0.
	useUCS2
		ifTrue: [
			ShortMessageTPDUHelper formatFromOctets: tpdu on: deliverSM.
			deliverSM dataCoding: dcs]
		ifFalse: [
			ShortMessageTPDUHelper formatFromGSM7Bit: tpdu on: deliverSM.
			deliverSM dataCoding: dcs].

	^true
]

{ #category : #'as yet unclassified' }
ShortMessageDataCodingSchemeHelper class >> convertSMS: tpdu toDeliverSM: deliverSM [
	| dcs type |

	dcs := tpdu at: 'TP-DCS'.
	type := dcs bitShift: -4.

	(type bitAnd: 2r1100) = 0 ifTrue: [
		^self convertGeneralCoding: tpdu toDeliverSM: deliverSM].
	(type bitAnd: 2r1111) = 2r1100 ifTrue: [
		^self convertMessageWaitingIndication: tpdu toDeliverSM: deliverSM ucs2: false].
	(type bitAnd: 2r1111) = 2r1101 ifTrue: [
		^self convertMessageWaitingIndication: tpdu toDeliverSM: deliverSM ucs2: false].
	(type bitAnd: 2r1111) = 2r1110 ifTrue: [
		^self convertMessageWaitingIndication: tpdu toDeliverSM: deliverSM ucs2: true].
	(type bitAnd: 2r1111) = 2r1111 ifTrue: [
		^self convertDataCoding: tpdu toDeliverSM: deliverSM].
	^false
]
