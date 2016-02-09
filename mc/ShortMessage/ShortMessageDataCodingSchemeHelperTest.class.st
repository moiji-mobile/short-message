"
A HomeRoutingDataCodingSchemeHelperTest is a test class for testing the behavior of HomeRoutingDataCodingSchemeHelper
"
Class {
	#name : #ShortMessageDataCodingSchemeHelperTest,
	#superclass : #TestCase,
	#category : #'ShortMessage-Tests'
}

{ #category : #'general-roundtrip' }
ShortMessageDataCodingSchemeHelperTest >> testGeneralDataCoding8BitData [
	| res deliverSM conv |
	res := {
		'TP-UDHI' -> false.
		'TP-UD' -> '1234' asByteArray.
		'TP-DCS' -> 2r0100.  } asDictionary.

	"Verify 8bit data is mapped correctly"
	deliverSM := SMPPDeliverSM new.
	deliverSM registeredDelivery: 0.

	self assert: (ShortMessageDataCodingSchemeHelper convertSMS: res toDeliverSM: deliverSM).
	self assert: deliverSM dataCoding equals: 2r01.
	self assert: deliverSM shortMessage equals: '1234' asByteArray.
	self assert: (deliverSM esmClass bitShift: -6) equals: 2r00.

	conv := deliverSM toDeliverTPDUDictionary.
	self assert: (conv at: 'TP-DCS') equals: 2r0100.
]

{ #category : #'general-roundtrip' }
ShortMessageDataCodingSchemeHelperTest >> testGeneralDataCoding8BitDataUDHI [
	| res deliverSM conv |
	res := {
		'TP-UDHI' -> true.
		'TP-UDH' -> #[9 8 7 6].
		'TP-UD' -> #[30 29 28].
		'TP-DCS' -> 2r0100.  } asDictionary.

	"Verify 8bit data is mapped correctly"
	deliverSM := SMPPDeliverSM new.
	deliverSM registeredDelivery: 0.

	self assert: (ShortMessageDataCodingSchemeHelper convertSMS: res toDeliverSM: deliverSM).
	self assert: deliverSM dataCoding equals: 2r01.
	self assert: deliverSM shortMessage equals: #[4 9 8 7 6 30 29 28].
	self assert: (deliverSM esmClass bitShift: -6) equals: 2r01.

	conv := deliverSM toDeliverTPDUDictionary.
	self assert: (conv at: 'TP-UDHI').
	self assert: (conv at: 'TP-UDH') equals: #[9 8 7 6].
	self assert: (conv at: 'TP-UD') equals: #[30 29 28].
	self assert: (conv at: 'TP-UD-Len') equals: 8.
	self assert: (conv at: 'TP-DCS') equals: 2r0100.
]

{ #category : #'general-impossible' }
ShortMessageDataCodingSchemeHelperTest >> testGeneralDataCodingMessageClass [
	| res |
	res := {
		'TP-UDHI' -> false.
		'TP-UD' -> '1234' asUSSD7Bit.
		'TP-UD-Len' -> 4.
		'TP-DCS' -> 2r00010000.  } asDictionary.

	"We can't map the message class. So verify we fail"
	self deny: (ShortMessageDataCodingSchemeHelper convertSMS: res toDeliverSM: SMPPDeliverSM new).
]

{ #category : #'general-impossible' }
ShortMessageDataCodingSchemeHelperTest >> testGeneralDataCodingReserved [
	| res deliverSM |
	res := {
		'TP-UDHI' -> false.
		'TP-UD' -> #[0 30].
		'TP-DCS' -> 2r1100.  } asDictionary.

	"Verify 8bit data is mapped correctly"
	deliverSM := SMPPDeliverSM new.
	self deny: (ShortMessageDataCodingSchemeHelper convertSMS: res toDeliverSM: deliverSM).
]

{ #category : #'general-roundtrip' }
ShortMessageDataCodingSchemeHelperTest >> testGeneralDataCodingUCS2 [
	| res deliverSM conv |
	res := {
		'TP-UDHI' -> false.
		'TP-UD' -> #[0 30].
		'TP-DCS' -> 2r1000.  } asDictionary.

	"Verify 8bit data is mapped correctly"
	deliverSM := SMPPDeliverSM new.
	deliverSM registeredDelivery: 0.

	self assert: (ShortMessageDataCodingSchemeHelper convertSMS: res toDeliverSM: deliverSM).
	self assert: deliverSM dataCoding equals: 2r1000.
	self assert: deliverSM shortMessage equals: #[0 30].
	self assert: (deliverSM esmClass bitShift: -6) equals: 2r00.

	conv := deliverSM toDeliverTPDUDictionary.
	self assert: (conv at: 'TP-DCS') equals: 2r1000.
	self deny: (conv at: 'TP-UDHI').
]

{ #category : #'general-roundtrip' }
ShortMessageDataCodingSchemeHelperTest >> testGeneralDataCodingUCS2UDH [
	| res deliverSM conv |
	res := {
		'TP-UDHI' -> true.
		'TP-UDH' -> #[250 1 2 3 4].
		'TP-UD' -> #[0 30].
		'TP-DCS' -> 2r1000.  } asDictionary.

	"Verify 8bit data is mapped correctly"
	deliverSM := SMPPDeliverSM new.
	deliverSM registeredDelivery: 0.

	self assert: (ShortMessageDataCodingSchemeHelper convertSMS: res toDeliverSM: deliverSM).
	self assert: deliverSM dataCoding equals: 2r1000.
	self assert: deliverSM shortMessage equals: #[5 250 1 2 3 4 0 30].
	self assert: (deliverSM esmClass bitShift: -6) equals: 2r01.

	conv := deliverSM toDeliverTPDUDictionary.
	self assert: (conv at: 'TP-DCS') equals: 2r1000.
	self assert: (conv at: 'TP-UDHI').
	self assert: (conv at: 'TP-UDH') equals: #[250 1 2 3 4].
]

{ #category : #'as yet unclassified' }
ShortMessageDataCodingSchemeHelperTest >> testMessageDataCoding7Bit [
	| res deliverSM conv |
	res := {
		'TP-UDHI' -> false.
		'TP-UD' -> '123' asUSSD7Bit.
		'TP-UD-Len' -> 3.
		'TP-DCS' -> 2r11110001.  } asDictionary.

	"Verify 8bit data is mapped correctly"
	deliverSM := SMPPDeliverSM new.
	deliverSM registeredDelivery: 0.

	self assert: (ShortMessageDataCodingSchemeHelper convertSMS: res toDeliverSM: deliverSM).
	self assert: deliverSM dataCoding equals: 2r11110001.
	self assert: deliverSM shortMessage equals: '123' asByteArray.
	self assert: (deliverSM esmClass bitShift: -6) equals: 2r00.

	conv := deliverSM toDeliverTPDUDictionary.
	self assert: (conv at: 'TP-DCS') equals: 2r11110001.
	self assert: (conv at: 'TP-UD') equals: '123' asUSSD7Bit.
]

{ #category : #'as yet unclassified' }
ShortMessageDataCodingSchemeHelperTest >> testMessageDataCodingUCS2 [
	| res deliverSM conv |
	res := {
		'TP-UDHI' -> false.
		'TP-UD' -> #[10 20 30].
		'TP-UD-Len' -> 3.
		'TP-DCS' -> 2r11110101.  } asDictionary.

	"Verify 8bit data is mapped correctly"
	deliverSM := SMPPDeliverSM new.
	deliverSM registeredDelivery: 0.

	self assert: (ShortMessageDataCodingSchemeHelper convertSMS: res toDeliverSM: deliverSM).
	self assert: deliverSM dataCoding equals: 2r11110101.
	self assert: deliverSM shortMessage equals: #[10 20 30].
	self assert: (deliverSM esmClass bitShift: -6) equals: 2r00.

	conv := deliverSM toDeliverTPDUDictionary.
	self assert: (conv at: 'TP-DCS') equals: 2r11110101.
	self assert: (conv at: 'TP-UD') equals: #[10 20 30].
]

{ #category : #'as yet unclassified' }
ShortMessageDataCodingSchemeHelperTest >> testMessageWaiting7bitDiscard [
	| res deliverSM conv |
	res := {
		'TP-UDHI' -> false.
		'TP-UD' -> '1234' asUSSD7Bit.
		'TP-UD-Len' -> 4.
		'TP-DCS' -> 2r11001010.  } asDictionary.

	"Verify 8bit data is mapped correctly"
	deliverSM := SMPPDeliverSM new.
	deliverSM registeredDelivery: 0.

	self assert: (ShortMessageDataCodingSchemeHelper convertSMS: res toDeliverSM: deliverSM).
	self assert: deliverSM dataCoding equals: 2r11001010.
	self assert: deliverSM shortMessage equals: '1234' asByteArray.
	self assert: (deliverSM esmClass bitShift: -6) equals: 2r00.

	conv := deliverSM toDeliverTPDUDictionary.
	self assert: (conv at: 'TP-DCS') equals: 2r11001010.
]

{ #category : #'as yet unclassified' }
ShortMessageDataCodingSchemeHelperTest >> testMessageWaiting7bitStore [
	| res deliverSM conv |
	res := {
		'TP-UDHI' -> false.
		'TP-UD' -> '1234' asUSSD7Bit.
		'TP-UD-Len' -> 4.
		'TP-DCS' -> 2r11011010.  } asDictionary.

	"Verify 8bit data is mapped correctly"
	deliverSM := SMPPDeliverSM new.
	deliverSM registeredDelivery: 0.

	self assert: (ShortMessageDataCodingSchemeHelper convertSMS: res toDeliverSM: deliverSM).
	self assert: deliverSM dataCoding equals: 2r11011010.
	self assert: deliverSM shortMessage equals: '1234' asByteArray.
	self assert: (deliverSM esmClass bitShift: -6) equals: 2r00.

	conv := deliverSM toDeliverTPDUDictionary.
	self assert: (conv at: 'TP-DCS') equals: 2r11011010.
	self assert: (conv at: 'TP-UD') equals: '1234' asUSSD7Bit.
]

{ #category : #'as yet unclassified' }
ShortMessageDataCodingSchemeHelperTest >> testMessageWaiting7bitUCS2 [
	| res deliverSM conv |
	res := {
		'TP-UDHI' -> false.
		'TP-UD' -> #[0 23 0 24].
		'TP-DCS' -> 2r11101010.  } asDictionary.

	"Verify 8bit data is mapped correctly"
	deliverSM := SMPPDeliverSM new.
	deliverSM registeredDelivery: 0.

	self assert: (ShortMessageDataCodingSchemeHelper convertSMS: res toDeliverSM: deliverSM).
	self assert: deliverSM dataCoding equals: 2r11101010.
	self assert: deliverSM shortMessage equals: #[0 23 0 24].
	self assert: (deliverSM esmClass bitShift: -6) equals: 2r00.

	conv := deliverSM toDeliverTPDUDictionary.
	self assert: (conv at: 'TP-DCS') equals: 2r11101010.
]
