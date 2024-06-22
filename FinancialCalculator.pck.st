'From Cuis7.1 [latest update: #6472] on 22 June 2024 at 2:59:43 pm'!
'Description '!
!provides: 'FinancialCalculator' 1 2!
SystemOrganization addCategory: #'FinancialCalculator-Tests'!
SystemOrganization addCategory: 'FinancialCalculator'!


!classDefinition: #TVMTests category: #'FinancialCalculator-Tests'!
TestCase subclass: #TVMTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialCalculator-Tests'!
!classDefinition: 'TVMTests class' category: #'FinancialCalculator-Tests'!
TVMTests class
	instanceVariableNames: ''!

!classDefinition: #TVM category: 'FinancialCalculator'!
Object subclass: #TVM
	instanceVariableNames: 'period money'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialCalculator'!
!classDefinition: 'TVM class' category: 'FinancialCalculator'!
TVM class
	instanceVariableNames: ''!

!classDefinition: #TVMCollection category: 'FinancialCalculator'!
Object subclass: #TVMCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialCalculator'!
!classDefinition: 'TVMCollection class' category: 'FinancialCalculator'!
TVMCollection class
	instanceVariableNames: ''!

!classDefinition: #Annuity category: 'FinancialCalculator'!
TVMCollection subclass: #Annuity
	instanceVariableNames: 'annuity first last'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialCalculator'!
!classDefinition: 'Annuity class' category: 'FinancialCalculator'!
Annuity class
	instanceVariableNames: ''!

!classDefinition: #Perpetuity category: 'FinancialCalculator'!
TVMCollection subclass: #Perpetuity
	instanceVariableNames: 'annuity'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialCalculator'!
!classDefinition: 'Perpetuity class' category: 'FinancialCalculator'!
Perpetuity class
	instanceVariableNames: ''!


!TVMTests methodsFor: 'testing' stamp: 'nafiz 6/22/2024 12:40:43'!
testFutureToPresent
	| tvm futureTVM |
	tvm := TVM
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

!TVMTests methodsFor: 'testing' stamp: 'nafiz 6/22/2024 12:44:06'!
testPresentToFuture
	| tvm pastTVM |
	tvm := TVM
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

!TVM methodsFor: 'accessing' stamp: 'nafiz 6/22/2024 10:56:24'!
money
^money! !

!TVM methodsFor: 'accessing' stamp: 'nafiz 6/22/2024 11:20:58'!
period
^period! !

!TVM methodsFor: 'tvm' stamp: 'nafiz 6/22/2024 12:48:11'!
atPeriod: aPeriod interestRate: aInterestRate
| periodShiftAmount |
periodShiftAmount := aPeriod - period.
^ self shiftPeriodBy: periodShiftAmount interestRate: aInterestRate.! !

!TVM methodsFor: 'tvm' stamp: 'nafiz 6/22/2024 12:48:25'!
shiftPeriodBy: aPeriodShiftAmount interestRate: aInterestRate
	^ TVM
		period: period + aPeriodShiftAmount
		money: money * (1 + aInterestRate raisedTo: aPeriodShiftAmount).! !

!TVM methodsFor: 'private' stamp: 'nafiz 6/22/2024 10:55:50'!
setMoney: aMoney
money := aMoney! !

!TVM methodsFor: 'private' stamp: 'nafiz 6/22/2024 11:25:27'!
setPeriod: aPeriod
	period := aPeriod.! !

!TVM class methodsFor: 'instance creation' stamp: 'nafiz 6/22/2024 13:07:31'!
period: aTime money: aMoney
	^ self
		new;
		setPeriod: aTime;
		setMoney: aMoney.! !

!TVMCollection methodsFor: 'tvm' stamp: 'nafiz 6/22/2024 13:52:47'!
moneyAtPeriod: aPeriod interestRate: aInterestRate
	| totalMoney |
	totalMoney := 0.
	self do: [ :tvm | | newTVM |
		newTVM := tvm
			atPeriod: aPeriod
			interestRate: aInterestRate.
		totalMoney := totalMoney + newTVM money ].
	^ TVM
		period: aPeriod
		money: totalMoney.! !

!TVMCollection methodsFor: 'accessing' stamp: 'nafiz 6/22/2024 13:55:56'!
size
	self subclassResponsibility.! !

!TVMCollection methodsFor: 'enumerating' stamp: 'nafiz 6/22/2024 14:56:39'!
do: aBlock

	self subclassResponsibility! !

!TVMCollection methodsFor: 'evaluating' stamp: 'nafiz 6/22/2024 13:52:59'!
tvmAtPeriod: aPeriod
	self do: [ :tvm |
		tvm period = aPeriod ifTrue: [ ^ tvm ]].
	^ nil.! !

!TVMCollection class methodsFor: 'instance creation' stamp: 'nafiz 6/22/2024 13:08:09'!
TVMs: someTVMs
	^self
		new;
		setTVMs: someTVMs.! !

!Annuity methodsFor: 'accessing' stamp: 'nafiz 6/22/2024 14:51:20'!
size
	^ last - first + 1.! !

!Annuity methodsFor: 'enumerating' stamp: 'nafiz 6/22/2024 14:51:46'!
do: aBlock
	first
		to: first + self size
		do: [ :period |
			TVM
				period: period
				money: annuity ].! !

!Perpetuity methodsFor: 'enumerating' stamp: 'nafiz 6/22/2024 14:57:04'!
do: aBlock
	self shouldNotImplement.! !

!Number methodsFor: '*FinancialCalculator' stamp: 'nafiz 6/22/2024 12:40:10'!
percent
^ self / 100! !
