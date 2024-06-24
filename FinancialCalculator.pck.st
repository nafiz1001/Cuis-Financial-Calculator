'From Cuis7.1 [latest update: #6472] on 23 June 2024 at 9:51:06 pm'!
'Description '!
!provides: 'FinancialCalculator' 1 8!
SystemOrganization addCategory: #'FinancialCalculator-Tests'!
SystemOrganization addCategory: #FinancialCalculator!


!classDefinition: #TVMTests category: #'FinancialCalculator-Tests'!
TestCase subclass: #TVMTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialCalculator-Tests'!
!classDefinition: 'TVMTests class' category: #'FinancialCalculator-Tests'!
TVMTests class
	instanceVariableNames: ''!

!classDefinition: #TVM category: #FinancialCalculator!
Object subclass: #TVM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialCalculator'!
!classDefinition: 'TVM class' category: #FinancialCalculator!
TVM class
	instanceVariableNames: ''!

!classDefinition: #Perpetuity category: #FinancialCalculator!
TVM subclass: #Perpetuity
	instanceVariableNames: 'annuity firstPeriod'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialCalculator'!
!classDefinition: 'Perpetuity class' category: #FinancialCalculator!
Perpetuity class
	instanceVariableNames: ''!

!classDefinition: #TVMCollection category: #FinancialCalculator!
TVM subclass: #TVMCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialCalculator'!
!classDefinition: 'TVMCollection class' category: #FinancialCalculator!
TVMCollection class
	instanceVariableNames: ''!

!classDefinition: #Annuity category: #FinancialCalculator!
TVMCollection subclass: #Annuity
	instanceVariableNames: 'annuity firstPeriod lastPeriod'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialCalculator'!
!classDefinition: 'Annuity class' category: #FinancialCalculator!
Annuity class
	instanceVariableNames: ''!

!classDefinition: #TVMPoint category: #FinancialCalculator!
TVM subclass: #TVMPoint
	instanceVariableNames: 'period money'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialCalculator'!
!classDefinition: 'TVMPoint class' category: #FinancialCalculator!
TVMPoint class
	instanceVariableNames: ''!


!TVMTests methodsFor: 'testing' stamp: 'nafiz 6/22/2024 15:38:50'!
testFutureToPresent
	| tvm futureTVM |
	tvm := TVMPoint
		period: 1
		money: 1.
	futureTVM := tvm
		shiftPeriodBy: -1
		interestRate: 100 percent.
	self
		assert: futureTVM period
		equals: 0.
	self
		assert: futureTVM money
		equals: 1 / 2.! !

!TVMTests methodsFor: 'testing' stamp: 'nafiz 6/22/2024 15:38:50'!
testPresentToFuture
	| tvm pastTVM |
	tvm := TVMPoint
		period: 0
		money: 1.
	pastTVM := tvm
		shiftPeriodBy: 1
		interestRate: 100 percent.
	self
		assert: pastTVM period
		equals: 1.
	self
		assert: pastTVM money
		equals: 2.! !

!TVM methodsFor: 'tvm' stamp: 'nafiz 6/22/2024 15:58:26'!
atPeriod: aPeriod

	self subclassResponsibility! !

!TVM methodsFor: 'tvm' stamp: 'nafiz 6/22/2024 15:42:22'!
atPeriod: aPeriod interestRate: aInterestRate

	self subclassResponsibility! !

!Perpetuity methodsFor: 'private' stamp: 'nafiz 6/23/2024 11:17:38'!
setAnnuity: aAnnuity
annuity := aAnnuity ! !

!Perpetuity methodsFor: 'private' stamp: 'nafiz 6/23/2024 11:05:33'!
setFirstPeriod: aFirstPeriod
firstPeriod := aFirstPeriod ! !

!Perpetuity methodsFor: 'tvm' stamp: 'nafiz 6/23/2024 11:07:41'!
atPeriod: aPeriod
aPeriod >= firstPeriod ifTrue: [
	^ TVMPoint
		period: aPeriod
		money: annuity.
		] ifFalse: [ ^nil]! !

!Perpetuity methodsFor: 'tvm' stamp: 'nafiz 6/23/2024 21:36:14'!
atPeriod: aPeriod interestRate: aInterestRate
| tvm |
			tvm := TVMPoint
				period: firstPeriod
				money: annuity / aInterestRate.
			tvm := tvm
				shiftPeriodBy: aPeriod
				interestRate: aInterestRate.
			^ tvm.! !

!Perpetuity class methodsFor: 'instance creation' stamp: 'nafiz 6/23/2024 11:17:01'!
annuity: aAnnuity firstPeriod: aFirstPeriod
| instance |
instance := self new.
^ instance setAnnuity: aAnnuity ; setFirstPeriod: aFirstPeriod.! !

!TVMCollection methodsFor: 'tvm' stamp: 'nafiz 6/22/2024 18:32:37'!
atPeriod: aPeriod
	self do: [ :tvm | | foundTVM |
		foundTVM := tvm atPeriod: aPeriod.
		foundTVM ifNotNil: [ ^foundTVM ] ].
	^ nil! !

!TVMCollection methodsFor: 'tvm' stamp: 'nafiz 6/22/2024 15:38:50'!
atPeriod: aPeriod interestRate: aInterestRate
	| totalMoney |
	totalMoney := 0.
	self do: [ :tvm | | newTVM |
		newTVM := tvm
			atPeriod: aPeriod
			interestRate: aInterestRate.
		totalMoney := totalMoney + newTVM money ].
	^ TVMPoint
		period: aPeriod
		money: totalMoney.! !

!TVMCollection methodsFor: 'enumerating' stamp: 'nafiz 6/22/2024 15:15:20'!
do: aBlock
	self subclassResponsibility! !

!Annuity methodsFor: 'enumerating' stamp: 'nafiz 6/23/2024 11:14:00'!
do: aBlock
	firstPeriod
		to: lastPeriod + 1
		do: [ :period |
			aBlock value: (TVMPoint
				period: period
				money: annuity) ].! !

!Annuity methodsFor: 'private' stamp: 'nafiz 6/23/2024 11:09:03'!
setAnnuity: aAnnuity
annuity := aAnnuity ! !

!Annuity methodsFor: 'private' stamp: 'nafiz 6/23/2024 11:09:19'!
setFirstPeriod: aFirstPeriod
firstPeriod := aFirstPeriod ! !

!Annuity methodsFor: 'private' stamp: 'nafiz 6/23/2024 11:09:35'!
setLastPeriod: aLastPeriod
	lastPeriod := 	aLastPeriod .! !

!Annuity class methodsFor: 'instance creation' stamp: 'nafiz 6/23/2024 11:20:04'!
annuity: aAnnuity firstPeriod: aFirstPeriod lastPeriod: aLastPeriod
	| instance |
	instance := self new.
	^ instance
		setAnnuity: aAnnuity;
		setFirstPeriod: aFirstPeriod;
		setLastPeriod: aLastPeriod.! !

!TVMPoint methodsFor: 'accessing' stamp: 'nafiz 6/22/2024 10:56:24'!
money
^money! !

!TVMPoint methodsFor: 'accessing' stamp: 'nafiz 6/22/2024 11:20:58'!
period
^period! !

!TVMPoint methodsFor: 'tvm' stamp: 'nafiz 6/22/2024 18:26:09'!
atPeriod: aPeriod
	aPeriod = period ifTrue: [ ^ self ] ifFalse: [ ^ nil ]! !

!TVMPoint methodsFor: 'tvm' stamp: 'nafiz 6/23/2024 21:50:10'!
atPeriod: aPeriod interestRate: aInterestRate
	^ self
		shiftPeriodBy: aPeriod - period
		interestRate: aInterestRate.! !

!TVMPoint methodsFor: 'tvm' stamp: 'nafiz 6/23/2024 21:47:50'!
shiftPeriodBy: aPeriodShiftAmount interestRate: aInterestRate
	^ TVMPoint
		period: period + aPeriodShiftAmount
		money:
			money *
				(aInterestRate zero
					ifTrue: [ 1 ]
					ifFalse: [ 1 + aInterestRate raisedTo: aPeriodShiftAmount ]).! !

!TVMPoint methodsFor: 'private' stamp: 'nafiz 6/22/2024 10:55:50'!
setMoney: aMoney
money := aMoney! !

!TVMPoint methodsFor: 'private' stamp: 'nafiz 6/22/2024 11:25:27'!
setPeriod: aPeriod
	period := aPeriod.! !

!TVMPoint class methodsFor: 'instance creation' stamp: 'nafiz 6/23/2024 11:10:29'!
period: aTime money: aMoney
| instance |
instance := self new.
	^ instance
		setPeriod: aTime;
		setMoney: aMoney.! !

!Number methodsFor: '*FinancialCalculator' stamp: 'nafiz 6/22/2024 12:40:10'!
percent
^ self / 100! !
