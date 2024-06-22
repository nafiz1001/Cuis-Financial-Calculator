'From Cuis7.1 [latest update: #6472] on 22 June 2024 at 6:53:16 pm'!
'Description '!
!provides: 'FinancialCalculator' 1 6!
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
	instanceVariableNames: 'annuity'
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
	instanceVariableNames: 'annuity totalPeriod'
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

!Perpetuity methodsFor: 'tvm' stamp: 'nafiz 6/22/2024 15:58:55'!
atPeriod: aPeriod
	^ TVMPoint period: aPeriod money: annuity! !

!Perpetuity methodsFor: 'tvm' stamp: 'nafiz 6/22/2024 18:41:37'!
atPeriod: aPeriod interestRate: aInterestRate
	aPeriod isInfinite
		ifTrue: [ ^ TVMPoint
				period: aPeriod
				money: aPeriod"can't reference Infinity so pass the infinite argument" ]
		ifFalse: [ | tvm |
			tvm := TVMPoint
				period: 0
				money: annuity / aInterestRate.
			tvm := tvm
				shiftPeriodBy: aPeriod
				interestRate: aInterestRate.
			^ tvm ].! !

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

!Annuity methodsFor: 'enumerating' stamp: 'nafiz 6/22/2024 15:50:02'!
do: aBlock
	1
		to: totalPeriod
		do: [ :period |
			TVMPoint
				period: period
				money: annuity ].! !

!TVMPoint methodsFor: 'accessing' stamp: 'nafiz 6/22/2024 10:56:24'!
money
^money! !

!TVMPoint methodsFor: 'accessing' stamp: 'nafiz 6/22/2024 11:20:58'!
period
^period! !

!TVMPoint methodsFor: 'tvm' stamp: 'nafiz 6/22/2024 18:26:09'!
atPeriod: aPeriod
	aPeriod = period ifTrue: [ ^ self ] ifFalse: [ ^ nil ]! !

!TVMPoint methodsFor: 'tvm' stamp: 'nafiz 6/22/2024 12:48:11'!
atPeriod: aPeriod interestRate: aInterestRate
| periodShiftAmount |
periodShiftAmount := aPeriod - period.
^ self shiftPeriodBy: periodShiftAmount interestRate: aInterestRate.! !

!TVMPoint methodsFor: 'tvm' stamp: 'nafiz 6/22/2024 15:38:50'!
shiftPeriodBy: aPeriodShiftAmount interestRate: aInterestRate
	^ TVMPoint
		period: period + aPeriodShiftAmount
		money: money * (1 + aInterestRate raisedTo: aPeriodShiftAmount).! !

!TVMPoint methodsFor: 'private' stamp: 'nafiz 6/22/2024 10:55:50'!
setMoney: aMoney
money := aMoney! !

!TVMPoint methodsFor: 'private' stamp: 'nafiz 6/22/2024 11:25:27'!
setPeriod: aPeriod
	period := aPeriod.! !

!TVMPoint class methodsFor: 'instance creation' stamp: 'nafiz 6/22/2024 13:07:31'!
period: aTime money: aMoney
	^ self
		new;
		setPeriod: aTime;
		setMoney: aMoney.! !

!Number methodsFor: '*FinancialCalculator' stamp: 'nafiz 6/22/2024 12:40:10'!
percent
^ self / 100! !
