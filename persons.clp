; Этот блок реализует логику обмена информацией с графической оболочкой,
; а также механизм остановки и повторного пуска машины вывода
; Русский текст в комментариях разрешён!
(deftemplate ioproxy		; шаблон факта-посредника для обмена информацией с GUI
	(slot fact-id)		; теоретически тут id факта для изменения
	(multislot answers)	; возможные ответы
	(multislot messages)	; исходящие сообщения
	(slot reaction)		; возможные ответы пользователя
	(slot value)		; выбор пользователя
	(slot restore)		; забыл зачем это поле
)

; Собственно экземпляр факта ioproxy
(deffacts proxy-fact
	(ioproxy
		(fact-id 0112)	; это поле пока что не задействовано
		(value none)	; значение пустое
		(messages)	; мультислот messages изначально пуст
	)
)

(defrule clear-messages
	(declare (salience 90))
	?clear-msg-flg <- (clearmessage)
	?proxy <- (ioproxy)
	=>
	(modify ?proxy (messages))
	(retract ?clear-msg-flg)
	(printout t "Messages cleared ..." crlf)
)

(defrule set-output-and-halt
	(declare (salience 99))
	?current-message <- (sendmessagehalt ?new-msg)
	?proxy <- (ioproxy (messages $?msg-list))
	=>
	(printout t "Message set : " ?new-msg " ... halting ... " crlf)
	(modify ?proxy (messages ?new-msg))
	(retract ?current-message)
	(halt)
)

(defrule append-output-and-halt
	(declare (salience 99))
	?current-message <- (appendmessagehalt $?new-msg)
	?proxy <- (ioproxy (messages $?msg-list))
	=>
	(printout t "Messages appended : " $?new-msg " ... halting ... " crlf) 
	(modify ?proxy (messages $?msg-list $?new-msg))
	(retract ?current-message)
	(halt)
)

(defrule set-output-and-proceed
	(declare (salience 99))
	?current-message <- (sendmessage ?new-msg)
	?proxy <- (ioproxy)
	=>
	(printout t "Message set : " ?new-msg " ... proceed ... " crlf)
	(modify ?proxy (messages ?new-msg))
	(retract ?current-message)
)

(defrule append-output-and-proceed
	(declare (salience 99))
	?current-message <- (appendmessage ?new-msg)
	?proxy <- (ioproxy (messages $?msg-list))
	=>
	(printout t "Message appended : " ?new-msg " ... proceed ... " crlf)
	(modify ?proxy (messages $?msg-list ?new-msg))
	(retract ?current-message)
)

; это правило не работает - исправить (тут нужна печать списка)
(defrule print-messages
	(declare (salience 99))
	?proxy <- (ioproxy (messages ?msg-list))
	?update-key <- (updated True)
	=>
	(retract ?update-key)
	(printout t "Messages received : " ?msg-list crlf)
)

;==================================================================================

(deftemplate element
	(slot formula)
)

(defrule greeting
	(declare (salience 100))
	=>
	(assert (appendmessagehalt "Добро пожаловать в дурацкий клипс!"))
	(assert (element (formula Котик)))
)

(defrule Электричество_ДигидрогенаМонооксид_Электролиз
   (declare (salience 40))
   (element (formula Электричество))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Электролиз)))
   (assert (appendmessagehalt "Электричество + H2O -> e"))
)


(defrule Киноварь_СульфидРтути
   (declare (salience 40))
   (element (formula Киноварь))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфидРтути)))
   (assert (appendmessagehalt "Киноварь -> HgS"))
)


(defrule Воздух_Кислород_Азот_УглекислыйГаз
   (declare (salience 40))
   (element (formula Воздух))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Кислород)))
   (assert (element (formula Азот)))
   (assert (element (formula УглекислыйГаз)))
   (assert (appendmessagehalt "Воздух -> O2 + N2 + CO2"))
)


(defrule ЩавелеваяКислота_ЩавелеваяКислота
   (declare (salience 40))
   (element (formula ЩавелеваяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ЩавелеваяКислота)))
   (assert (appendmessagehalt "ЩавелеваяКислота -> H2C2O4"))
)


(defrule Песок_ОксидКремния
   (declare (salience 40))
   (element (formula Песок))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидКремния)))
   (assert (appendmessagehalt "Песок -> SiO2"))
)


(defrule Известняк_КарбонатКальция
   (declare (salience 40))
   (element (formula Известняк))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula КарбонатКальция)))
   (assert (appendmessagehalt "Известняк -> CaCO3"))
)


(defrule Вода_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Вода))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "Вода -> H2O"))
)


(defrule Боксит_ГидроксидАлюминия_ОксидЖелеза3_ОксидЖелеза
   (declare (salience 40))
   (element (formula Боксит))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидроксидАлюминия)))
   (assert (element (formula ОксидЖелеза3)))
   (assert (element (formula ОксидЖелеза)))
   (assert (appendmessagehalt "Боксит -> Al(OH)3 + Fe2O3 + FeO"))
)


(defrule Магнетит_ОксидЖелеза_ОксидЖелеза3
   (declare (salience 40))
   (element (formula Магнетит))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидЖелеза)))
   (assert (element (formula ОксидЖелеза3)))
   (assert (appendmessagehalt "Магнетит -> FeO + Fe2O3"))
)


(defrule Малахит_Малахит
   (declare (salience 40))
   (element (formula Малахит))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Малахит)))
   (assert (appendmessagehalt "Малахит -> (CuOH)2CO3"))
)


(defrule Соль_ХлоридНатрия
   (declare (salience 40))
   (element (formula Соль))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлоридНатрия)))
   (assert (appendmessagehalt "Соль -> NaCl"))
)


(defrule Барит_СульфатБария
   (declare (salience 40))
   (element (formula Барит))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфатБария)))
   (assert (appendmessagehalt "Барит -> BaSO4"))
)


(defrule Пиролюзит_ОксидМарганца
   (declare (salience 40))
   (element (formula Пиролюзит))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидМарганца)))
   (assert (appendmessagehalt "Пиролюзит -> MnO2"))
)


(defrule Фосфорит_ОксидФосфора
   (declare (salience 40))
   (element (formula Фосфорит))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидФосфора)))
   (assert (appendmessagehalt "Фосфорит -> P4O10 "))
)


(defrule Пирит_СульфидЖелеза
   (declare (salience 40))
   (element (formula Пирит))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфидЖелеза)))
   (assert (appendmessagehalt "Пирит -> FeS2"))
)


(defrule МедныйКолчедан_Халькопирит
   (declare (salience 40))
   (element (formula МедныйКолчедан))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Халькопирит)))
   (assert (appendmessagehalt "МедныйКолчедан -> CuFeS2"))
)


(defrule Галенит_СульфидСвинца
   (declare (salience 40))
   (element (formula Галенит))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфидСвинца)))
   (assert (appendmessagehalt "Галенит -> PbS"))
)


(defrule Уголь_Углерод
   (declare (salience 40))
   (element (formula Уголь))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Углерод)))
   (assert (appendmessagehalt "Уголь -> C"))
)


(defrule Котик_Тепло
   (declare (salience 40))
   (element (formula Котик))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Тепло)))
   (assert (appendmessagehalt "Котик -> t"))
)


(defrule Кислород_Водород_ДигидрогенаМонооксид_Тепло
   (declare (salience 40))
   (element (formula Кислород))
   (element (formula Водород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (element (formula Тепло)))
   (assert (appendmessagehalt "O2 + H2 -> H2O + t"))
)


(defrule Кислород_Тепло_Озон
   (declare (salience 40))
   (element (formula Кислород))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Озон)))
   (assert (appendmessagehalt "O2 + t -> O3"))
)


(defrule Кислород_Свет_Озон
   (declare (salience 40))
   (element (formula Кислород))
   (element (formula Свет))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Озон)))
   (assert (appendmessagehalt "O2 + hv -> O3"))
)


(defrule Озон_Кислород_Тепло
   (declare (salience 40))
   (element (formula Озон))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Кислород)))
   (assert (element (formula Тепло)))
   (assert (appendmessagehalt "O3 -> O2 + t"))
)


(defrule ДигидрогенаМонооксид_Электролиз_Водород_Кислород
   (declare (salience 40))
   (element (formula ДигидрогенаМонооксид))
   (element (formula Электролиз))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Водород)))
   (assert (element (formula Кислород)))
   (assert (appendmessagehalt "H2O + e -> H2  + O2"))
)


(defrule Сера_Кислород_МонооксидСеры_ДиоксидСеры_ТриоксидСеры
   (declare (salience 40))
   (element (formula Сера))
   (element (formula Кислород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula МонооксидСеры)))
   (assert (element (formula ДиоксидСеры)))
   (assert (element (formula ТриоксидСеры)))
   (assert (appendmessagehalt "S + O2 -> SO  + SO2 + SO3"))
)


(defrule Фтор_Кислород_ОксидФтора
   (declare (salience 40))
   (element (formula Фтор))
   (element (formula Кислород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидФтора)))
   (assert (appendmessagehalt "F2 + O2 -> F2O"))
)


(defrule Азот_Кислород_ОксидАзота1_ОксидАзота2_ОксидАзота3_ОксидАзота4_ОксидАзота5
   (declare (salience 40))
   (element (formula Азот))
   (element (formula Кислород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидАзота1)))
   (assert (element (formula ОксидАзота2)))
   (assert (element (formula ОксидАзота3)))
   (assert (element (formula ОксидАзота4)))
   (assert (element (formula ОксидАзота5)))
   (assert (appendmessagehalt "N2 + O2 -> N2O + NO + N2O3 + NO2 + N2O5"))
)


(defrule ОксидАзота2_Кислород_ОксидАзота4
   (declare (salience 40))
   (element (formula ОксидАзота2))
   (element (formula Кислород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидАзота4)))
   (assert (appendmessagehalt "NO + O2 -> NO2"))
)


(defrule Углерод_Кислород_УгарныйГаз_УглекислыйГаз_Тепло
   (declare (salience 40))
   (element (formula Углерод))
   (element (formula Кислород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula УгарныйГаз)))
   (assert (element (formula УглекислыйГаз)))
   (assert (element (formula Тепло)))
   (assert (appendmessagehalt "C + O2 -> CO + CO2 + t"))
)


(defrule Натрий_Кислород_ОксидНатрия_Тепло
   (declare (salience 40))
   (element (formula Натрий))
   (element (formula Кислород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидНатрия)))
   (assert (element (formula Тепло)))
   (assert (appendmessagehalt "Na + O2 -> NaO + t"))
)


(defrule Калий_Кислород_ОксидКалия_Тепло
   (declare (salience 40))
   (element (formula Калий))
   (element (formula Кислород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидКалия)))
   (assert (element (formula Тепло)))
   (assert (appendmessagehalt "K + O2 -> K2O + t"))
)


(defrule ТриоксидСеры_ДигидрогенаМонооксид_СернаяКислота
   (declare (salience 40))
   (element (formula ТриоксидСеры))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СернаяКислота)))
   (assert (appendmessagehalt "SO3 + H2O -> H2SO4"))
)


(defrule СернаяКислота_Электролиз_ПероксодисернаяКислота_Водород
   (declare (salience 40))
   (element (formula СернаяКислота))
   (element (formula Электролиз))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПероксодисернаяКислота)))
   (assert (element (formula Водород)))
   (assert (appendmessagehalt "H2SO4 + e -> H2S2O8 + H2"))
)


(defrule ПероксодисернаяКислота_ДигидрогенаМонооксид_ПероксидВодорода_СернаяКислота
   (declare (salience 40))
   (element (formula ПероксодисернаяКислота))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПероксидВодорода)))
   (assert (element (formula СернаяКислота)))
   (assert (appendmessagehalt "H2S2O8 + H2O -> H2O2 + H2SO4"))
)


(defrule СолянаяКислота_ДиоксидСеры_ХлорсульфоноваяКислота
   (declare (salience 40))
   (element (formula СолянаяКислота))
   (element (formula ДиоксидСеры))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлорсульфоноваяКислота)))
   (assert (appendmessagehalt "HCl + SO2 -> HSO3Cl"))
)


(defrule Водород_Хлор_СолянаяКислота
   (declare (salience 40))
   (element (formula Водород))
   (element (formula Хлор))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СолянаяКислота)))
   (assert (appendmessagehalt "H2 + Cl2 -> HCl"))
)


(defrule ГидроксидНатрия_Хлор_ХлоридНатрия_ГипохлоритНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидНатрия))
   (element (formula Хлор))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлоридНатрия)))
   (assert (element (formula ГипохлоритНатрия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "NaOH + Cl2 -> NaCl + NaOCl + H2O"))
)


(defrule Натрий_ДигидрогенаМонооксид_ГидроксидНатрия_Водород
   (declare (salience 40))
   (element (formula Натрий))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидроксидНатрия)))
   (assert (element (formula Водород)))
   (assert (appendmessagehalt "Na + H2O -> NaOH + H2"))
)


(defrule ХлоридНатрия_СернаяКислота_ГидросульфатНатрия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридНатрия))
   (element (formula СернаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидросульфатНатрия)))
   (assert (element (formula СолянаяКислота)))
   (assert (appendmessagehalt "NaCl + H2SO4 -> NaHSO4 + HCl"))
)


(defrule Калий_ДигидрогенаМонооксид_ГидроксидКалия
   (declare (salience 40))
   (element (formula Калий))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидроксидКалия)))
   (assert (appendmessagehalt "K + H2O -> KOH"))
)


(defrule АзотнаяКислота_Свет_ОксидАзота2_ДигидрогенаМонооксид_Кислород
   (declare (salience 40))
   (element (formula АзотнаяКислота))
   (element (formula Свет))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидАзота2)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (element (formula Кислород)))
   (assert (appendmessagehalt "HNO3 + hv -> NO + H2O + O2"))
)


(defrule Метан_Кислород_ОксидАзота2_ДигидрогенаМонооксид_Тепло
   (declare (salience 40))
   (element (formula Метан))
   (element (formula Кислород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидАзота2)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (element (formula Тепло)))
   (assert (appendmessagehalt "NH3 + O2 -> NO + H2O + t"))
)


(defrule ОксидАзота4_Кислород_ДигидрогенаМонооксид_АзотнаяКислота_Тепло
   (declare (salience 40))
   (element (formula ОксидАзота4))
   (element (formula Кислород))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula АзотнаяКислота)))
   (assert (element (formula Тепло)))
   (assert (appendmessagehalt "NO2 + O2 + H2O -> HNO3 + t"))
)


(defrule Азот_Водород_Метан_Тепло
   (declare (salience 40))
   (element (formula Азот))
   (element (formula Водород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Метан)))
   (assert (element (formula Тепло)))
   (assert (appendmessagehalt "N2 + H2 -> NH3 + t"))
)


(defrule Метан_Тепло_Азот_Водород
   (declare (salience 40))
   (element (formula Метан))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Азот)))
   (assert (element (formula Водород)))
   (assert (appendmessagehalt "NH3 + t -> N2 + H2"))
)


(defrule ДигидрогенаМонооксид_УглекислыйГаз_УгольнаяКислота
   (declare (salience 40))
   (element (formula ДигидрогенаМонооксид))
   (element (formula УглекислыйГаз))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula УгольнаяКислота)))
   (assert (appendmessagehalt "H2O + CO2 -> H2CO3"))
)


(defrule УгольнаяКислота_ДигидрогенаМонооксид_УглекислыйГаз
   (declare (salience 40))
   (element (formula УгольнаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (element (formula УглекислыйГаз)))
   (assert (appendmessagehalt "H2CO3 -> H2O + CO2"))
)


(defrule КарбонатНатрия_СолянаяКислота_ХлоридНатрия_УгольнаяКислота
   (declare (salience 40))
   (element (formula КарбонатНатрия))
   (element (formula СолянаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлоридНатрия)))
   (assert (element (formula УгольнаяКислота)))
   (assert (appendmessagehalt "Na2CO3 + HCl -> NaCl + H2CO3"))
)


(defrule СиликатНатрия_СолянаяКислота_МетакремниеваяКислота_ХлоридНатрия
   (declare (salience 40))
   (element (formula СиликатНатрия))
   (element (formula СолянаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula МетакремниеваяКислота)))
   (assert (element (formula ХлоридНатрия)))
   (assert (appendmessagehalt "Na2SiO3 + HCl -> H2SiO3 + NaCl"))
)


(defrule Дихлорсилан_ДигидрогенаМонооксид_СернистаяКислота_СолянаяКислота_Водород
   (declare (salience 40))
   (element (formula Дихлорсилан))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СернистаяКислота)))
   (assert (element (formula СолянаяКислота)))
   (assert (element (formula Водород)))
   (assert (appendmessagehalt "SiH2Cl2 + H2O -> H2SO3 + HCl + H2"))
)


(defrule ОксидАзота3_ДигидрогенаМонооксид_АзотистаяКислота
   (declare (salience 40))
   (element (formula ОксидАзота3))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula АзотистаяКислота)))
   (assert (appendmessagehalt "N2O3 + H2O -> HNO2"))
)


(defrule ОксидАзота4_ДигидрогенаМонооксид_АзотнаяКислота_АзотистаяКислота
   (declare (salience 40))
   (element (formula ОксидАзота4))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula АзотнаяКислота)))
   (assert (element (formula АзотистаяКислота)))
   (assert (appendmessagehalt "NO2 + H2O -> HNO3 + HNO2"))
)


(defrule Фосфор_АзотнаяКислота_ДигидрогенаМонооксид_ОртофосфорнаяКислота_ОксидАзота2
   (declare (salience 40))
   (element (formula Фосфор))
   (element (formula АзотнаяКислота))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОртофосфорнаяКислота)))
   (assert (element (formula ОксидАзота2)))
   (assert (appendmessagehalt "P + HNO3 + H2O -> H3PO4 + NO"))
)


(defrule БелыйФосфор_Кислород_Тепло_ОксидФосфора
   (declare (salience 40))
   (element (formula БелыйФосфор))
   (element (formula Кислород))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидФосфора)))
   (assert (appendmessagehalt "P4 + O2 + t -> P4O10"))
)


(defrule ОксидФосфора_ДигидрогенаМонооксид_ОртофосфорнаяКислота
   (declare (salience 40))
   (element (formula ОксидФосфора))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОртофосфорнаяКислота)))
   (assert (appendmessagehalt "P4O10 + H2O -> H3PO4"))
)


(defrule ОксидФосфора3_ДигидрогенаМонооксид_ФосфористаяКислота
   (declare (salience 40))
   (element (formula ОксидФосфора3))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ФосфористаяКислота)))
   (assert (appendmessagehalt "P2O3 + H2O -> H3PO3"))
)


(defrule ХлоридФосфора_ДигидрогенаМонооксид_ФосфористаяКислота_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридФосфора))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ФосфористаяКислота)))
   (assert (element (formula СолянаяКислота)))
   (assert (appendmessagehalt "PCl3 + H2O -> H3PO3 + HCl"))
)


(defrule ГидрофосфатКалия_СолянаяКислота_ХлоридКалия_ФосфористаяКислота
   (declare (salience 40))
   (element (formula ГидрофосфатКалия))
   (element (formula СолянаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлоридКалия)))
   (assert (element (formula ФосфористаяКислота)))
   (assert (appendmessagehalt "K2HPO3 + HCl -> KCl + H3PO3"))
)


(defrule ОксидХрома_ДигидрогенаМонооксид_ХромоваяКислота_ДихромоваяКислота
   (declare (salience 40))
   (element (formula ОксидХрома))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХромоваяКислота)))
   (assert (element (formula ДихромоваяКислота)))
   (assert (appendmessagehalt "CrO3 + H2O -> H2CrO4 + H2Cr2O7"))
)


(defrule Хлор_ДигидрогенаМонооксид_ХлорноватистаяКислота_СолянаяКислота
   (declare (salience 40))
   (element (formula Хлор))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлорноватистаяКислота)))
   (assert (element (formula СолянаяКислота)))
   (assert (appendmessagehalt "Cl2 + H2O -> HClO + HCl"))
)


(defrule ОксидХлора_ДигидрогенаМонооксид_ХлорноватистаяКислота
   (declare (salience 40))
   (element (formula ОксидХлора))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлорноватистаяКислота)))
   (assert (appendmessagehalt "Cl2O + H2O -> HClO"))
)


(defrule ОксидХлора_ПероксидВодорода_ГидроксидНатрия_ХлоритНатрия_Кислород_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидХлора))
   (element (formula ПероксидВодорода))
   (element (formula ГидроксидНатрия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлоритНатрия)))
   (assert (element (formula Кислород)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "ClO2 + H2O2 + NaOH -> NaClO2 + O2 + H2O"))
)


(defrule ГипохлоритБария_СернаяКислота_СульфатБария_ХлористаяКислота
   (declare (salience 40))
   (element (formula ГипохлоритБария))
   (element (formula СернаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфатБария)))
   (assert (element (formula ХлористаяКислота)))
   (assert (appendmessagehalt "Ba(ClO2)2 + H2SO4 -> BaSO4 + HClO2"))
)


(defrule ХлоратБария_СернаяКислота_СульфатБария_ХлорноватаяКислота
   (declare (salience 40))
   (element (formula ХлоратБария))
   (element (formula СернаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфатБария)))
   (assert (element (formula ХлорноватаяКислота)))
   (assert (appendmessagehalt "Ba(ClO3)2 + H2SO4 -> BaSO4 + HClO3"))
)


(defrule ПерхлоратКалия_СернаяКислота_ГидросульфатКалия_ХлорнаяКислота
   (declare (salience 40))
   (element (formula ПерхлоратКалия))
   (element (formula СернаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидросульфатКалия)))
   (assert (element (formula ХлорнаяКислота)))
   (assert (appendmessagehalt "KClO4 + H2SO4 -> KHSO4 + HClO4"))
)


(defrule ПерманганатБария_СернаяКислота_МарганцоваяКислота_СульфатБария
   (declare (salience 40))
   (element (formula ПерманганатБария))
   (element (formula СернаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula МарганцоваяКислота)))
   (assert (element (formula СульфатБария)))
   (assert (appendmessagehalt "Ba(MnO4)2 + H2SO4 -> HMnO4 + BaSO4"))
)


(defrule ОксидМарганца_ДигидрогенаМонооксид_МарганцоваяКислота
   (declare (salience 40))
   (element (formula ОксидМарганца))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula МарганцоваяКислота)))
   (assert (appendmessagehalt "Mn2O7 + H2O -> HMnO4"))
)


(defrule СульфатНатрия_Углерод_СульфидНатрия_УглекислыйГаз
   (declare (salience 40))
   (element (formula СульфатНатрия))
   (element (formula Углерод))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфидНатрия)))
   (assert (element (formula УглекислыйГаз)))
   (assert (appendmessagehalt "Na2SO4 + C -> Na2S + CO2"))
)


(defrule СульфидНатрия_КарбонатКальция_КарбонатНатрия_СульфидКальция
   (declare (salience 40))
   (element (formula СульфидНатрия))
   (element (formula КарбонатКальция))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula КарбонатНатрия)))
   (assert (element (formula СульфидКальция)))
   (assert (appendmessagehalt "Na2S + CaCO3 -> Na2CO3 + CaS"))
)


(defrule ХлоридНатрия_СернаяКислота_СульфатНатрия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридНатрия))
   (element (formula СернаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфатНатрия)))
   (assert (element (formula СолянаяКислота)))
   (assert (appendmessagehalt "NaCl + H2SO4 -> Na2SO4 + HCl"))
)


(defrule Метан_УглекислыйГаз_ДигидрогенаМонооксид_ХлоридНатрия_ГидрокарбонатНатрия_ХлоридАммония
   (declare (salience 40))
   (element (formula Метан))
   (element (formula УглекислыйГаз))
   (element (formula ДигидрогенаМонооксид))
   (element (formula ХлоридНатрия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидрокарбонатНатрия)))
   (assert (element (formula ХлоридАммония)))
   (assert (appendmessagehalt "NH3 + CO2 + H2O + NaCl -> NaHCO3 + HN4Cl"))
)


(defrule ГидрокарбонатНатрия_Тепло_КарбонатНатрия_ДигидрогенаМонооксид_УглекислыйГаз
   (declare (salience 40))
   (element (formula ГидрокарбонатНатрия))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula КарбонатНатрия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (element (formula УглекислыйГаз)))
   (assert (appendmessagehalt "NaHCO3 + t -> Na2CO3 + H2O + CO2"))
)


(defrule ОксидКремния_ГидроксидНатрия_СиликатНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидКремния))
   (element (formula ГидроксидНатрия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СиликатНатрия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "SiO2 + NaOH -> Na2SiO3 + H2O"))
)


(defrule ОксидКремния_КарбонатНатрия_СиликатНатрия_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидКремния))
   (element (formula КарбонатНатрия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СиликатНатрия)))
   (assert (element (formula УглекислыйГаз)))
   (assert (appendmessagehalt "SiO2 + Na2CO3 -> Na2SiO3 + CO2"))
)


(defrule ОртосиликатНатрия_Тепло_СиликатНатрия_ОксидНатрия
   (declare (salience 40))
   (element (formula ОртосиликатНатрия))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СиликатНатрия)))
   (assert (element (formula ОксидНатрия)))
   (assert (appendmessagehalt "Na4SiO4 + t -> Na2SiO3 + Na2O"))
)


(defrule СлоридАммония_ГидроксидНатрия_Метан_ХлоридНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СлоридАммония))
   (element (formula ГидроксидНатрия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Метан)))
   (assert (element (formula ХлоридНатрия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "NH4Cl + NaOH -> NH3 + NaCl + H2O"))
)


(defrule МетафосфорнаяКислота_Углерод_БелыйФосфор_ДигидрогенаМонооксид_УгарныйГаз
   (declare (salience 40))
   (element (formula МетафосфорнаяКислота))
   (element (formula Углерод))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula БелыйФосфор)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (element (formula УгарныйГаз)))
   (assert (appendmessagehalt "HPO3 + C -> P4 + H2O + CO"))
)


(defrule Фосфор_Кислород_ОксидФосфора5_ОксидФосфора3
   (declare (salience 40))
   (element (formula Фосфор))
   (element (formula Кислород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидФосфора5)))
   (assert (element (formula ОксидФосфора3)))
   (assert (appendmessagehalt "P + O2 -> P2O5 + P2O3"))
)


(defrule Фосфор_Кальций_ФосфидКальция
   (declare (salience 40))
   (element (formula Фосфор))
   (element (formula Кальций))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ФосфидКальция)))
   (assert (appendmessagehalt "P + Ca -> Ca3P2"))
)


(defrule Фосфор_Сера_СульфидФосфора
   (declare (salience 40))
   (element (formula Фосфор))
   (element (formula Сера))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфидФосфора)))
   (assert (appendmessagehalt "P + S -> P2S3"))
)


(defrule Фосфор_Хлор_ХлоридФосфора_ХлоридФосфора
   (declare (salience 40))
   (element (formula Фосфор))
   (element (formula Хлор))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлоридФосфора)))
   (assert (element (formula ХлоридФосфора)))
   (assert (appendmessagehalt "P + Cl2 -> PCl3 + PCl5"))
)


(defrule Фосфор_ДигидрогенаМонооксид_Тепло_Фосфин_ОртофосфорнаяКислота
   (declare (salience 40))
   (element (formula Фосфор))
   (element (formula ДигидрогенаМонооксид))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Фосфин)))
   (assert (element (formula ОртофосфорнаяКислота)))
   (assert (appendmessagehalt "P + H2O + t -> PH3 + H3PO4"))
)


(defrule Фосфор_ДигидрогенаМонооксид_Тепло_ОртофосфорнаяКислота_Водород
   (declare (salience 40))
   (element (formula Фосфор))
   (element (formula ДигидрогенаМонооксид))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОртофосфорнаяКислота)))
   (assert (element (formula Водород)))
   (assert (appendmessagehalt "P + H2O + t -> H3PO4 + H2"))
)


(defrule БелыйФосфор_Тепло_Фосфор
   (declare (salience 40))
   (element (formula БелыйФосфор))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Фосфор)))
   (assert (appendmessagehalt "P4 + t -> P"))
)


(defrule БелыйФосфор_Свет_Фосфор
   (declare (salience 40))
   (element (formula БелыйФосфор))
   (element (formula Свет))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Фосфор)))
   (assert (appendmessagehalt "P4 + hv -> P"))
)


(defrule БелыйФосфор_ОксидАзота1_ОксидФосфора_Азот
   (declare (salience 40))
   (element (formula БелыйФосфор))
   (element (formula ОксидАзота1))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидФосфора)))
   (assert (element (formula Азот)))
   (assert (appendmessagehalt "P4 + N2O -> P4O5 + N2"))
)


(defrule БелыйФосфор_УглекислыйГаз_ОксидФосфора_УгарныйГаз
   (declare (salience 40))
   (element (formula БелыйФосфор))
   (element (formula УглекислыйГаз))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидФосфора)))
   (assert (element (formula УгарныйГаз)))
   (assert (appendmessagehalt "P4 + CO2 -> P4O5 + CO"))
)


(defrule ДихроматНатрия_СернаяКислота_ОксидХрома_СульфатНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ДихроматНатрия))
   (element (formula СернаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидХрома)))
   (assert (element (formula СульфатНатрия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "Na2Cr2O7 + H2SO4 -> CrO3 + Na2SO4 + H2O"))
)


(defrule ОксидРтути_Хлор_ГипохлоридРтути_ОксидХлора
   (declare (salience 40))
   (element (formula ОксидРтути))
   (element (formula Хлор))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГипохлоридРтути)))
   (assert (element (formula ОксидХлора)))
   (assert (appendmessagehalt "HgO + Cl2 -> Hg2OCl2 + Cl2O"))
)


(defrule ОксидРтути_Хлор_ХлоридРтути_ОксидХлора
   (declare (salience 40))
   (element (formula ОксидРтути))
   (element (formula Хлор))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлоридРтути)))
   (assert (element (formula ОксидХлора)))
   (assert (appendmessagehalt "HgO + Cl2 -> HgCl2 + Cl2O"))
)


(defrule Хлор_КарбонатНатрия_ДигидрогенаМонооксид_ГидрокарбонатНатрия_ХлоридНатрия_ОксидХлора
   (declare (salience 40))
   (element (formula Хлор))
   (element (formula КарбонатНатрия))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидрокарбонатНатрия)))
   (assert (element (formula ХлоридНатрия)))
   (assert (element (formula ОксидХлора)))
   (assert (appendmessagehalt "Cl2 + Na2CO3 + H2O -> NaHCO3 + NaCl + Cl2O"))
)


(defrule ХлоратКалия_ЩавелеваяКислота_ОксидХлора_КарбонатКалия_УглекислыйГаз_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ХлоратКалия))
   (element (formula ЩавелеваяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидХлора)))
   (assert (element (formula КарбонатКалия)))
   (assert (element (formula УглекислыйГаз)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "KClO3 + H2C2O4 -> ClO2 + K2CO3 + CO2 + H2O"))
)


(defrule ХлоратНатрия_ДиоксидСеры_СернаяКислота_ГидросульфатНатрия_ОксидХлора
   (declare (salience 40))
   (element (formula ХлоратНатрия))
   (element (formula ДиоксидСеры))
   (element (formula СернаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидросульфатНатрия)))
   (assert (element (formula ОксидХлора)))
   (assert (appendmessagehalt "NaClO3 + SO2 + H2SO4 -> NaHSO4 + ClO2"))
)


(defrule ГидроксидБария_Хлор_ГипохлоритБария_ХлоридБария_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидБария))
   (element (formula Хлор))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГипохлоритБария)))
   (assert (element (formula ХлоридБария)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "Ba(OH)2 + Cl2 -> Ba(ClO)2 + BaCl2 + H2O"))
)


(defrule ХлоридБария_ДигидрогенаМонооксид_ГидроксидБария_Водород_Хлор
   (declare (salience 40))
   (element (formula ХлоридБария))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидроксидБария)))
   (assert (element (formula Водород)))
   (assert (element (formula Хлор)))
   (assert (appendmessagehalt "BaCl2 + H2O -> Ba(OH)2 + H2 + Cl2"))
)


(defrule ГидроксидБария_Хлор_ХлоридБария_ХлоратБария_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидБария))
   (element (formula Хлор))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлоридБария)))
   (assert (element (formula ХлоратБария)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "Ba(OH)2 + Cl2 -> BaCl2 + Ba(ClO3)2 + H2O"))
)


(defrule ПерхлоратНатрия_ХлоридКалия_ПерхлоратКалия_ХлоридНатрия
   (declare (salience 40))
   (element (formula ПерхлоратНатрия))
   (element (formula ХлоридКалия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПерхлоратКалия)))
   (assert (element (formula ХлоридНатрия)))
   (assert (appendmessagehalt "NaClO4 + KCl -> KClO4 + NaCl"))
)


(defrule ХлоратКалия_Электролиз_ПерхлоратКалия_ХлоридКалия
   (declare (salience 40))
   (element (formula ХлоратКалия))
   (element (formula Электролиз))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПерхлоратКалия)))
   (assert (element (formula ХлоридКалия)))
   (assert (appendmessagehalt "KClO3 + e -> KClO4 + KCl"))
)


(defrule ХлоратКалия_Тепло_ПерхлоратКалия_ХлоридКалия
   (declare (salience 40))
   (element (formula ХлоратКалия))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПерхлоратКалия)))
   (assert (element (formula ХлоридКалия)))
   (assert (appendmessagehalt "KClO3 + t -> KClO4 + KCl"))
)


(defrule ПерманганатКалия_СернаяКислота_ОксидМарганца_СульфатКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ПерманганатКалия))
   (element (formula СернаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидМарганца)))
   (assert (element (formula СульфатКалия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "KMnO4 + H2SO4 -> Mn2O7 + K2SO4 + H2O"))
)


(defrule ОксидМарганца_ОксидМарганца_Кислород_Озон_Тепло
   (declare (salience 40))
   (element (formula ОксидМарганца))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидМарганца)))
   (assert (element (formula Кислород)))
   (assert (element (formula Озон)))
   (assert (element (formula Тепло)))
   (assert (appendmessagehalt "Mn2O7 -> MnO2 + O2 + O3 + t"))
)


(defrule ОксидМарганца_ДигидрогенаМонооксид_МарганцоваяКислота
   (declare (salience 40))
   (element (formula ОксидМарганца))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula МарганцоваяКислота)))
   (assert (appendmessagehalt "Mn2O7 + H2O -> HMnO4"))
)


(defrule ХлоридНатрия_СернаяКислота_СульфатНатрия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридНатрия))
   (element (formula СернаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфатНатрия)))
   (assert (element (formula СолянаяКислота)))
   (assert (appendmessagehalt "NaCl + H2SO4 -> Na2SO4 + HCl"))
)


(defrule ОксидКальция_ДигидрогенаМонооксид_ГидроксидКальция
   (declare (salience 40))
   (element (formula ОксидКальция))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидроксидКальция)))
   (assert (appendmessagehalt "CaO + H2O -> Ca(OH)2"))
)


(defrule ГидроксидКальция_УглекислыйГаз_КарбонатКальция_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидКальция))
   (element (formula УглекислыйГаз))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula КарбонатКальция)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "Ca(OH)2 + CO2 -> CaCO3 + H2O"))
)


(defrule Кремний_ГидроксидНатрия_ОртосиликатНатрия_Водород
   (declare (salience 40))
   (element (formula Кремний))
   (element (formula ГидроксидНатрия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОртосиликатНатрия)))
   (assert (element (formula Водород)))
   (assert (appendmessagehalt "Si + NaOH -> Na4SiO4 + H2"))
)


(defrule ОксидКремния_ГидроксидНатрия_ОртосиликатНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидКремния))
   (element (formula ГидроксидНатрия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОртосиликатНатрия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "SiO2 + NaOH -> Na4SiO4 + H2O"))
)


(defrule ОксидКремния_КарбонатНатрия_ОртосиликатНатрия_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидКремния))
   (element (formula КарбонатНатрия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОртосиликатНатрия)))
   (assert (element (formula УглекислыйГаз)))
   (assert (appendmessagehalt "SiO2 + Na2CO3 -> Na4SiO4 + CO2"))
)


(defrule ОксидФосфора_ОксидФосфора5
   (declare (salience 40))
   (element (formula ОксидФосфора))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидФосфора5)))
   (assert (appendmessagehalt "P4O10 -> P2O5"))
)


(defrule ОксидФосфора5_ОксидФосфора
   (declare (salience 40))
   (element (formula ОксидФосфора5))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидФосфора)))
   (assert (appendmessagehalt "P2O5 -> P4O10"))
)


(defrule ОксидФосфора5_ДигидрогенаМонооксид_МетафосфорнаяКислота
   (declare (salience 40))
   (element (formula ОксидФосфора5))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula МетафосфорнаяКислота)))
   (assert (appendmessagehalt "P2O5 + H2O -> HPO3"))
)


(defrule СолянаяКислота_ГидроксидКалия_ХлоридКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СолянаяКислота))
   (element (formula ГидроксидКалия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлоридКалия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "HCl + KOH -> KCl + H2O"))
)


(defrule ОксидХрома_КарбонатНатрия_Кислород_Тепло_ДихроматНатрия
   (declare (salience 40))
   (element (formula ОксидХрома))
   (element (formula КарбонатНатрия))
   (element (formula Кислород))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ДихроматНатрия)))
   (assert (appendmessagehalt "Cr2O3 + Na2CO3 + O2 + t -> Na2Cr2O7"))
)


(defrule Ртуть_Кислород_Тепло_ОксидРтути
   (declare (salience 40))
   (element (formula Ртуть))
   (element (formula Кислород))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидРтути)))
   (assert (appendmessagehalt "Hg + O2 + t -> HgO"))
)


(defrule СульфидРтути_ГидроксидНатрия_ОксидРтути_СульфидНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СульфидРтути))
   (element (formula ГидроксидНатрия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидРтути)))
   (assert (element (formula СульфидНатрия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "HgS + NaOH -> HgO + Na2S + H2O"))
)


(defrule СульфидРтути_Кислород_Тепло_Ртуть_ДиоксидСеры
   (declare (salience 40))
   (element (formula СульфидРтути))
   (element (formula Кислород))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Ртуть)))
   (assert (element (formula ДиоксидСеры)))
   (assert (appendmessagehalt "HgS + O2 + t -> Hg + SO2"))
)


(defrule СульфидРтути_Железо_Тепло_Ртуть_ОксидЖелеза3
   (declare (salience 40))
   (element (formula СульфидРтути))
   (element (formula Железо))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Ртуть)))
   (assert (element (formula ОксидЖелеза3)))
   (assert (appendmessagehalt "HgS + Fe + t -> Hg + Fe2O3"))
)


(defrule Хлор_ГидроксидКалия_ХлоратКалия_ХлоридКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Хлор))
   (element (formula ГидроксидКалия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлоратКалия)))
   (assert (element (formula ХлоридКалия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "Cl2 + KOH -> KClO3 + KCl + H2O"))
)


(defrule ХлоратНатрия_ХлорноватаяКислота_ХлоратНатрия_ДигидрогенаМонооксид_УглекислыйГаз
   (declare (salience 40))
   (element (formula ХлоратНатрия))
   (element (formula ХлорноватаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлоратНатрия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (element (formula УглекислыйГаз)))
   (assert (appendmessagehalt "Na2ClO3 + HClO3 -> NaClO3 + H2O + CO2"))
)


(defrule ГидроксидНатрия_Хлор_ХлоратНатрия_ХлоридНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидНатрия))
   (element (formula Хлор))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлоратНатрия)))
   (assert (element (formula ХлоридНатрия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "NaOH + Cl2 -> NaClO3 + NaCl + H2O"))
)


(defrule ХлоридНатрия_ДигидрогенаМонооксид_Электролиз_ХлоратНатрия_ХлоридНатрия_Водород
   (declare (salience 40))
   (element (formula ХлоридНатрия))
   (element (formula ДигидрогенаМонооксид))
   (element (formula Электролиз))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлоратНатрия)))
   (assert (element (formula ХлоридНатрия)))
   (assert (element (formula Водород)))
   (assert (appendmessagehalt "NaCl + H2O + e -> NaClO3 + NaCl + H2"))
)


(defrule Барий_ДигидрогенаМонооксид_ГидроксидБария_Водород
   (declare (salience 40))
   (element (formula Барий))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидроксидБария)))
   (assert (element (formula Водород)))
   (assert (appendmessagehalt "Ba + H2O -> Ba(OH)2 + H2"))
)


(defrule ОксидБария_ДигидрогенаМонооксид_ГидроксидБария
   (declare (salience 40))
   (element (formula ОксидБария))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидроксидБария)))
   (assert (appendmessagehalt "BaO + H2O -> Ba(OH)2"))
)


(defrule СульфидБария_ДигидрогенаМонооксид_ГидроксидБария_Сероводород
   (declare (salience 40))
   (element (formula СульфидБария))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидроксидБария)))
   (assert (element (formula Сероводород)))
   (assert (appendmessagehalt "BaS + H2O -> Ba(OH)2 + H2S"))
)


(defrule ХлоратНатрия_Тепло_ПерхлоратНатрия_ХлоридНатрия
   (declare (salience 40))
   (element (formula ХлоратНатрия))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПерхлоратНатрия)))
   (assert (element (formula ХлоридНатрия)))
   (assert (appendmessagehalt "NaClO3 + t -> NaClO4 + NaCl"))
)


(defrule ОксидМарганца_Хлор_ГидроксидКалия_ПерманганатКалия_ХлоридКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМарганца))
   (element (formula Хлор))
   (element (formula ГидроксидКалия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПерманганатКалия)))
   (assert (element (formula ХлоридКалия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "MnO2 + Cl2 + KOH -> KMnO4 + KCl + H2O"))
)


(defrule ПерманганатКалия_Хлор_ПерманганатКалия_ХлоридКалия
   (declare (salience 40))
   (element (formula ПерманганатКалия))
   (element (formula Хлор))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПерманганатКалия)))
   (assert (element (formula ХлоридКалия)))
   (assert (appendmessagehalt "K2MnO4 + Cl2 -> KMnO4 + KCl"))
)


(defrule ПерманганатКалия_ДигидрогенаМонооксид_ПерманганатКалия_ОксидМарганца_ГидроксидКалия_Водород
   (declare (salience 40))
   (element (formula ПерманганатКалия))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПерманганатКалия)))
   (assert (element (formula ОксидМарганца)))
   (assert (element (formula ГидроксидКалия)))
   (assert (element (formula Водород)))
   (assert (appendmessagehalt "K2MnO4 + H2O -> KMnO4 + MnO2 + KOH + H2"))
)


(defrule КарбонатКальция_Тепло_ОксидКальция_УглекислыйГаз
   (declare (salience 40))
   (element (formula КарбонатКальция))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидКальция)))
   (assert (element (formula УглекислыйГаз)))
   (assert (appendmessagehalt "CaCO3 + t -> CaO + CO2"))
)


(defrule Кальций_Кислород_ОксидКальция
   (declare (salience 40))
   (element (formula Кальций))
   (element (formula Кислород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидКальция)))
   (assert (appendmessagehalt "Ca + O2 -> CaO"))
)


(defrule НитратКальция_Тепло_ОксидКальция_ОксидАзота4_Кислород
   (declare (salience 40))
   (element (formula НитратКальция))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидКальция)))
   (assert (element (formula ОксидАзота4)))
   (assert (element (formula Кислород)))
   (assert (appendmessagehalt "Ca(NO3)2 + t -> CaO + NO2 + O2"))
)


(defrule ОксидКремния_Марганец_Тепло_ОксидМарганца_Кремний
   (declare (salience 40))
   (element (formula ОксидКремния))
   (element (formula Марганец))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидМарганца)))
   (assert (element (formula Кремний)))
   (assert (appendmessagehalt "SiO2 + Mn + t -> MnO + Si"))
)


(defrule ХлоридРтути_Сероводород_Кордероит_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридРтути))
   (element (formula Сероводород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Кордероит)))
   (assert (element (formula СолянаяКислота)))
   (assert (appendmessagehalt "HgCl2 + H2S -> Hg3S2Cl2 + HCl"))
)


(defrule Кордероит_Сероводород_СульфидРтути_СолянаяКислота
   (declare (salience 40))
   (element (formula Кордероит))
   (element (formula Сероводород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфидРтути)))
   (assert (element (formula СолянаяКислота)))
   (assert (appendmessagehalt "Hg3S2Cl2 + H2S -> HgS + HCl"))
)


(defrule СульфатБария_Углерод_СульфидБария_УгарныйГаз
   (declare (salience 40))
   (element (formula СульфатБария))
   (element (formula Углерод))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфидБария)))
   (assert (element (formula УгарныйГаз)))
   (assert (appendmessagehalt "BaSO4 + C -> BaS + CO"))
)


(defrule ГидроксидБария_Сероводород_СульфидБария_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидБария))
   (element (formula Сероводород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфидБария)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "Ba(OH)2 + H2S -> BaS + H2O"))
)


(defrule ОксидМарганца_ГидроксидКалия_НитратКалия_Тепло_ПерманганатКалия_НитритКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМарганца))
   (element (formula ГидроксидКалия))
   (element (formula НитратКалия))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПерманганатКалия)))
   (assert (element (formula НитритКалия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "MnO2 + KOH + KNO3 + t -> K2MnO4 + KNO2 + H2O"))
)


(defrule ОксидМарганца_КарбонатКалия_ХлоратКалия_Тепло_ПерманганатКалия_ХлоридКалия_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидМарганца))
   (element (formula КарбонатКалия))
   (element (formula ХлоратКалия))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПерманганатКалия)))
   (assert (element (formula ХлоридКалия)))
   (assert (element (formula УглекислыйГаз)))
   (assert (appendmessagehalt "MnO2 + K2CO3 + KClO3 + t -> K2MnO4 + KCl + CO2"))
)


(defrule ОксидМарганца_ГидроксидКалия_Кислород_Тепло_ПерманганатКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМарганца))
   (element (formula ГидроксидКалия))
   (element (formula Кислород))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПерманганатКалия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "MnO2 + KOH + O2 + t -> K2MnO4 + H2O"))
)


(defrule ПерманганатКалия_Тепло_ПерманганатКалия_ОксидМарганца_Кислород
   (declare (salience 40))
   (element (formula ПерманганатКалия))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПерманганатКалия)))
   (assert (element (formula ОксидМарганца)))
   (assert (element (formula Кислород)))
   (assert (appendmessagehalt "KMnO4 + t -> K2MnO4 + MnO2 + O2"))
)


(defrule ОксидМарганца_ПероксидКалия_Тепло_ПерманганатКалия
   (declare (salience 40))
   (element (formula ОксидМарганца))
   (element (formula ПероксидКалия))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПерманганатКалия)))
   (assert (appendmessagehalt "MnO2 + K2O2 + t -> K2MnO4"))
)


(defrule КарбонатКальция_АзотнаяКислота_НитратКальция_УглекислыйГаз_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula КарбонатКальция))
   (element (formula АзотнаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula НитратКальция)))
   (assert (element (formula УглекислыйГаз)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "CaCO3 + HNO3 -> Ca(NO3)2 + CO2 + H2O"))
)


(defrule НитратКальция_Тепло_ОксидКальция_ОксидАзота4_Кислород
   (declare (salience 40))
   (element (formula НитратКальция))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидКальция)))
   (assert (element (formula ОксидАзота4)))
   (assert (element (formula Кислород)))
   (assert (appendmessagehalt "Ca(NO3)2 + t -> CaO + NO2 + O2"))
)


(defrule Кальций_АзотнаяКислота_НитратКальция_ОксидАзота1_ОксидАзота2_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Кальций))
   (element (formula АзотнаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula НитратКальция)))
   (assert (element (formula ОксидАзота1)))
   (assert (element (formula ОксидАзота2)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "Ca + HNO3 -> Ca(NO3)2 + N2O + NO + H2O"))
)


(defrule ОксидКальция_АзотнаяКислота_НитратКальция_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидКальция))
   (element (formula АзотнаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula НитратКальция)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "CaO + HNO3 -> Ca(NO3)2 + H2O"))
)


(defrule ГидроксидКальция_ОксидАзота4_НитратКальция_НитритКальция_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидКальция))
   (element (formula ОксидАзота4))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula НитратКальция)))
   (assert (element (formula НитритКальция)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "Ca(OH)2 + NO2 -> Ca(NO3)2 + Ca(NO2)2 + H2O"))
)


(defrule СульфидКальция_АзотнаяКислота_НитратКальция_Сера_ОксидАзота4_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СульфидКальция))
   (element (formula АзотнаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula НитратКальция)))
   (assert (element (formula Сера)))
   (assert (element (formula ОксидАзота4)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "CaS + HNO3 -> Ca(NO3)2 + S + NO2 + H2O"))
)


(defrule ОксидМарганца_Тепло_ОксидМарганца
   (declare (salience 40))
   (element (formula ОксидМарганца))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидМарганца)))
   (assert (appendmessagehalt "MnO2 + t -> Mn2O3"))
)


(defrule ОксидМарганца_Алюминий_Тепло_Марганец_ОксидАлюминия_Тепло
   (declare (salience 40))
   (element (formula ОксидМарганца))
   (element (formula Алюминий))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Марганец)))
   (assert (element (formula ОксидАлюминия)))
   (assert (element (formula Тепло)))
   (assert (appendmessagehalt "Mn2O3 + Al + t -> Mn + Al2O3 + t"))
)


(defrule СульфидРтути_ХлоридРтути_Тепло_Кордероит
   (declare (salience 40))
   (element (formula СульфидРтути))
   (element (formula ХлоридРтути))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Кордероит)))
   (assert (appendmessagehalt "HgS + HgCl2 + t -> Hg3S2Cl2"))
)


(defrule СульфидЖелеза_СолянаяКислота_Сероводород_ХлоридЖелеза
   (declare (salience 40))
   (element (formula СульфидЖелеза))
   (element (formula СолянаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Сероводород)))
   (assert (element (formula ХлоридЖелеза)))
   (assert (appendmessagehalt "FeS + HCl -> H2S + FeCl2"))
)


(defrule СульфидАлюминия_ДигидрогенаМонооксид_Сероводород_ГидроксидАлюминия
   (declare (salience 40))
   (element (formula СульфидАлюминия))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Сероводород)))
   (assert (element (formula ГидроксидАлюминия)))
   (assert (appendmessagehalt "Al2S3 + H2O -> H2S + Al(OH)3"))
)


(defrule НитратКальция_КарбонатКалия_НитратКалия_КарбонатКальция
   (declare (salience 40))
   (element (formula НитратКальция))
   (element (formula КарбонатКалия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula НитратКалия)))
   (assert (element (formula КарбонатКальция)))
   (assert (appendmessagehalt "Ca(NO3)2 + K2CO3 -> KNO3 + CaCO3"))
)


(defrule НитратКальция_СульфатКалия_НитратКалия_СульфатКальция
   (declare (salience 40))
   (element (formula НитратКальция))
   (element (formula СульфатКалия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula НитратКалия)))
   (assert (element (formula СульфатКальция)))
   (assert (appendmessagehalt "Ca(NO3)2 + K2SO4 -> KNO3 + CaSO4"))
)


(defrule Калий_Кислород_Холод_ПероксидКалия
   (declare (salience 40))
   (element (formula Калий))
   (element (formula Кислород))
   (element (formula Холод))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПероксидКалия)))
   (assert (appendmessagehalt "K + O2 + not_t -> K2O2"))
)


(defrule ОксидКальция_Тепло_ПероксидКалия_Кислород
   (declare (salience 40))
   (element (formula ОксидКальция))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ПероксидКалия)))
   (assert (element (formula Кислород)))
   (assert (appendmessagehalt "KO2 + t -> K2O2 + O2"))
)


(defrule ОксидАлюминия_Электролиз_Тепло_Криолит_Алюминий_Кислород_Криолит
   (declare (salience 40))
   (element (formula ОксидАлюминия))
   (element (formula Электролиз))
   (element (formula Тепло))
   (element (formula Криолит))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Алюминий)))
   (assert (element (formula Кислород)))
   (assert (element (formula Криолит)))
   (assert (appendmessagehalt "Al2O3 + e + t + Na3AlF6 -> Al + O2 + Na3AlF6"))
)


(defrule ХлоридАлюминия_Калий_Тепло_ХлоридКалия_Алюминий
   (declare (salience 40))
   (element (formula ХлоридАлюминия))
   (element (formula Калий))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлоридКалия)))
   (assert (element (formula Алюминий)))
   (assert (appendmessagehalt "AlCl3 + K + t -> KCl + Al"))
)


(defrule Железо_Сера_СульфидЖелеза
   (declare (salience 40))
   (element (formula Железо))
   (element (formula Сера))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфидЖелеза)))
   (assert (appendmessagehalt "Fe + S -> FeS"))
)


(defrule СульфидЖелеза_Тепло_СульфидЖелеза
   (declare (salience 40))
   (element (formula СульфидЖелеза))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфидЖелеза)))
   (assert (appendmessagehalt "FeS2 + t -> FeS"))
)


(defrule ОксидЖелеза3_Водород_Сероводород_СульфидЖелеза_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидЖелеза3))
   (element (formula Водород))
   (element (formula Сероводород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфидЖелеза)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "Fe2O3 + H2 + H2S -> FeS + H2O"))
)


(defrule Алюминий_Сера_Тепло_СульфидАлюминия
   (declare (salience 40))
   (element (formula Алюминий))
   (element (formula Сера))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфидАлюминия)))
   (assert (appendmessagehalt "Al + S + t -> Al2S3"))
)


(defrule Натрий_ГидроксидКалия_ГидроксидНатрия_Калий
   (declare (salience 40))
   (element (formula Натрий))
   (element (formula ГидроксидКалия))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидроксидНатрия)))
   (assert (element (formula Калий)))
   (assert (appendmessagehalt "Na + KOH -> NaOH + K"))
)


(defrule ОксидМеди_Алюминий_Тепло_ОксидАлюминия_Медь
   (declare (salience 40))
   (element (formula ОксидМеди))
   (element (formula Алюминий))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидАлюминия)))
   (assert (element (formula Медь)))
   (assert (appendmessagehalt "Cu2O + Al + t -> Al2O3 + Cu"))
)


(defrule ГидроксидАлюминия_Тепло_ОксидАлюминия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидАлюминия))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидАлюминия)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "Al(OH)3 + t -> Al2O3 + H2O"))
)


(defrule ОксидЖелеза3_Водород_Тепло_Железо_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидЖелеза3))
   (element (formula Водород))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Железо)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "Fe2O3 + H2 + t -> Fe + H2O"))
)


(defrule ОксидЖелеза3_УгарныйГаз_Железо_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидЖелеза3))
   (element (formula УгарныйГаз))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Железо)))
   (assert (element (formula УглекислыйГаз)))
   (assert (appendmessagehalt "Fe2O3 + CO -> Fe + CO2"))
)


(defrule ОксидЖелеза_УгарныйГаз_Железо_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидЖелеза))
   (element (formula УгарныйГаз))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Железо)))
   (assert (element (formula УглекислыйГаз)))
   (assert (appendmessagehalt "FeO + CO -> Fe + CO2"))
)


(defrule ОксидЖелеза_УгарныйГаз_Железо_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидЖелеза))
   (element (formula УгарныйГаз))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Железо)))
   (assert (element (formula УглекислыйГаз)))
   (assert (appendmessagehalt "FeO + CO -> Fe + CO2"))
)


(defrule ОксидЖелеза3_Алюминий_Железо_ОксидАлюминия
   (declare (salience 40))
   (element (formula ОксидЖелеза3))
   (element (formula Алюминий))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Железо)))
   (assert (element (formula ОксидАлюминия)))
   (assert (appendmessagehalt "Fe2O3 + Al -> Fe + Al2O3"))
)


(defrule Медь_Кислород_Тепло_ОксидМеди2_ОксидМеди
   (declare (salience 40))
   (element (formula Медь))
   (element (formula Кислород))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидМеди2)))
   (assert (element (formula ОксидМеди)))
   (assert (appendmessagehalt "Cu + O2 + t -> CuO + Cu2O"))
)


(defrule Медь_ОксидАзота1_Тепло_ОксидМеди_Азот
   (declare (salience 40))
   (element (formula Медь))
   (element (formula ОксидАзота1))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидМеди)))
   (assert (element (formula Азот)))
   (assert (appendmessagehalt "Cu + N2O + t -> Cu2O + N2"))
)


(defrule ОксидМеди2_Углерод_Медь_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидМеди2))
   (element (formula Углерод))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Медь)))
   (assert (element (formula УглекислыйГаз)))
   (assert (appendmessagehalt "CuO + C -> Cu + CO2"))
)


(defrule ОксидМеди2_Водород_Медь_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМеди2))
   (element (formula Водород))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Медь)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "CuO + H2 -> Cu + H2O"))
)


(defrule Малахит_Тепло_ОксидМеди2_УглекислыйГаз_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Малахит))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ОксидМеди2)))
   (assert (element (formula УглекислыйГаз)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "(CuOH)2CO3 + t -> CuO + CO2 + H2O"))
)


(defrule Малахит_УгарныйГаз_Тепло_УглекислыйГаз_Медь_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Малахит))
   (element (formula УгарныйГаз))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula УглекислыйГаз)))
   (assert (element (formula Медь)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "(CuOH)2CO3 + CO + t -> CO2 + Cu + H2O"))
)


(defrule ХлоридБария_Электролиз_Барий_Хлор
   (declare (salience 40))
   (element (formula ХлоридБария))
   (element (formula Электролиз))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Барий)))
   (assert (element (formula Хлор)))
   (assert (appendmessagehalt "BaCl2 + e -> Ba + Cl2"))
)


(defrule СолянаяКислота_ОксидМарганца_Хлор_ХлоридМарганца_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СолянаяКислота))
   (element (formula ОксидМарганца))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Хлор)))
   (assert (element (formula ХлоридМарганца)))
   (assert (element (formula ДигидрогенаМонооксид)))
   (assert (appendmessagehalt "HCl + MnO2 -> Cl2 + MnCl2 + H2O"))
)


(defrule ХлоридНатрия_Электролиз_Натрий_Хлор
   (declare (salience 40))
   (element (formula ХлоридНатрия))
   (element (formula Электролиз))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Натрий)))
   (assert (element (formula Хлор)))
   (assert (appendmessagehalt "NaCl + e -> Na + Cl2"))
)


(defrule ХлоридКалия_ДигидрогенаМонооксид_Электролиз_ГидроксидКалия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридКалия))
   (element (formula ДигидрогенаМонооксид))
   (element (formula Электролиз))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидроксидКалия)))
   (assert (element (formula СолянаяКислота)))
   (assert (appendmessagehalt "KCl + H2O + e -> KOH + HCl"))
)


(defrule Халькопирит_Кислород_Тепло_СульфидМеди_ОксидЖелеза
   (declare (salience 40))
   (element (formula Халькопирит))
   (element (formula Кислород))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфидМеди)))
   (assert (element (formula ОксидЖелеза)))
   (assert (appendmessagehalt "CuFeS2 + O2 + t -> Cu2S + FeO"))
)


(defrule СульфидМеди_ДигидрогенаМонооксид_Тепло_Медь_ДиоксидСеры_Водород
   (declare (salience 40))
   (element (formula СульфидМеди))
   (element (formula ДигидрогенаМонооксид))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Медь)))
   (assert (element (formula ДиоксидСеры)))
   (assert (element (formula Водород)))
   (assert (appendmessagehalt "Cu2S + H2O + t -> Cu + SO2 + H2"))
)


(defrule СульфидМеди_Тепло_Медь_Сера
   (declare (salience 40))
   (element (formula СульфидМеди))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Медь)))
   (assert (element (formula Сера)))
   (assert (appendmessagehalt "Cu2S + t -> Cu + S"))
)


(defrule СульфидСвинца_СолянаяКислота_ХлоридСвинца_Сероводород
   (declare (salience 40))
   (element (formula СульфидСвинца))
   (element (formula СолянаяКислота))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ХлоридСвинца)))
   (assert (element (formula Сероводород)))
   (assert (appendmessagehalt "PbS + HCl -> PbCl2 + H2S"))
)


(defrule СульфидСвинца_Водород_Тепло_Свинец_Сероводород
   (declare (salience 40))
   (element (formula СульфидСвинца))
   (element (formula Водород))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Свинец)))
   (assert (element (formula Сероводород)))
   (assert (appendmessagehalt "PbS + H2 + t -> Pb + H2S"))
)


(defrule СульфидСвинца_Озон_СульфатСвинца_Кислород
   (declare (salience 40))
   (element (formula СульфидСвинца))
   (element (formula Озон))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula СульфатСвинца)))
   (assert (element (formula Кислород)))
   (assert (appendmessagehalt "PbS + O3 -> PbSO4 + O2"))
)


(defrule ХлоридСвинца_ДигидрогенаМонооксид_ГидроксидХлоридСвинца_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридСвинца))
   (element (formula ДигидрогенаМонооксид))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula ГидроксидХлоридСвинца)))
   (assert (element (formula СолянаяКислота)))
   (assert (appendmessagehalt "PbCl2 + H2O -> Pb(OH)Cl + HCl"))
)


(defrule ХлоридСвинца_Водород_Тепло_Свинец_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридСвинца))
   (element (formula Водород))
   (element (formula Тепло))
   =>
   (printout t "----------------------" crlf)
   (assert (element (formula Свинец)))
   (assert (element (formula СолянаяКислота)))
   (assert (appendmessagehalt "PbCl2 + H2 + t -> Pb + HCl"))
)
