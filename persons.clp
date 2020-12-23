(deftemplate ioproxy		; шаблон факта-посредника для обмена информацией с GUI
	(slot fact-id)		; теоретически тут id факта для изменения
	(multislot answers)	; возможные ответы
	(multislot messages)	; исходящие сообщения
	(slot reaction)		; возможные ответы пользователя
	(slot value)		; выбор пользователя
	(slot restore)		; забыл зачем это поле
)

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
)

(defrule set-output-and-halt
	(declare (salience 99))
	?current-message <- (sendmessagehalt ?new-msg)
	?proxy <- (ioproxy (messages $?msg-list))
	=>
	(modify ?proxy (messages ?new-msg))
	(retract ?current-message)
	(halt)
)

(defrule append-output-and-halt
	(declare (salience 99))
	?current-message <- (appendmessagehalt $?new-msg)
	?proxy <- (ioproxy (messages $?msg-list))
	=>
	(modify ?proxy (messages $?msg-list $?new-msg))
	(retract ?current-message)
	(halt)
)

(defrule set-output-and-proceed
	(declare (salience 99))
	?current-message <- (sendmessage ?new-msg)
	?proxy <- (ioproxy)
	=>
	(modify ?proxy (messages ?new-msg))
	(retract ?current-message)
)

(defrule append-output-and-proceed
	(declare (salience 99))
	?current-message <- (appendmessage ?new-msg)
	?proxy <- (ioproxy (messages $?msg-list))
	=>
	(modify ?proxy (messages $?msg-list ?new-msg))
	(retract ?current-message)
)

;==================================================================================

(deftemplate element
	(slot formula)
	(slot mass)
)

(defrule greeting
	(declare (salience 100))
	=>
	(assert (appendmessagehalt "Колба пуста. Добавьте что-нибудь."))
)


(defrule Электричество_ДигидрогенаМонооксид_Электролиз
   (declare (salience 40))
   (element (formula Электричество) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula Электролиз) (mass (* (/ (+ ?m0 ?m1) 2) 0.6416969))))
   (assert (appendmessagehalt (str-cat "Электричество (" ?m0 ") + H2O (" ?m1 ") -(0.6416969)> e (" (* (/ (+ ?m0 ?m1) 2) 0.6416969) ")")))
)


(defrule Киноварь_СульфидРтути
   (declare (salience 40))
   (element (formula Киноварь) (mass ?m0))
   =>
   (assert (element (formula СульфидРтути) (mass (* (/ ?m0 1) 0.5647898))))
   (assert (appendmessagehalt (str-cat "Киноварь (" ?m0 ") -(0.5647898)> HgS (" (* (/ ?m0 1) 0.5647898) ")")))
)


(defrule Воздух_Кислород_Азот_УглекислыйГаз
   (declare (salience 40))
   (element (formula Воздух) (mass ?m0))
   =>
   (assert (element (formula Кислород) (mass (* (/ ?m0 1) 0.4153983))))
   (assert (element (formula Азот) (mass (* (/ ?m0 1) 0.4153983))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ ?m0 1) 0.4153983))))
   (assert (appendmessagehalt (str-cat "Воздух (" ?m0 ") -(0.4153983)> O2 (" (* (/ ?m0 1) 0.4153983) ") + N2 (" (* (/ ?m0 1) 0.4153983) ") + CO2 (" (* (/ ?m0 1) 0.4153983) ")")))
)


(defrule ЩавелеваяКислота_ЩавелеваяКислота
   (declare (salience 40))
   (element (formula ЩавелеваяКислота) (mass ?m0))
   =>
   (assert (element (formula ЩавелеваяКислота) (mass (* (/ ?m0 1) 0.5043926))))
   (assert (appendmessagehalt (str-cat "ЩавелеваяКислота (" ?m0 ") -(0.5043926)> H2C2O4 (" (* (/ ?m0 1) 0.5043926) ")")))
)


(defrule Песок_ОксидКремния
   (declare (salience 40))
   (element (formula Песок) (mass ?m0))
   =>
   (assert (element (formula ОксидКремния) (mass (* (/ ?m0 1) 0.9261883))))
   (assert (appendmessagehalt (str-cat "Песок (" ?m0 ") -(0.9261883)> SiO2 (" (* (/ ?m0 1) 0.9261883) ")")))
)


(defrule Известняк_КарбонатКальция
   (declare (salience 40))
   (element (formula Известняк) (mass ?m0))
   =>
   (assert (element (formula КарбонатКальция) (mass (* (/ ?m0 1) 0.8824096))))
   (assert (appendmessagehalt (str-cat "Известняк (" ?m0 ") -(0.8824096)> CaCO3 (" (* (/ ?m0 1) 0.8824096) ")")))
)


(defrule Вода_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Вода) (mass ?m0))
   =>
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ ?m0 1) 0.5953146))))
   (assert (appendmessagehalt (str-cat "Вода (" ?m0 ") -(0.5953146)> H2O (" (* (/ ?m0 1) 0.5953146) ")")))
)


(defrule Боксит_ГидроксидАлюминия_ОксидЖелеза3_ОксидЖелеза
   (declare (salience 40))
   (element (formula Боксит) (mass ?m0))
   =>
   (assert (element (formula ГидроксидАлюминия) (mass (* (/ ?m0 1) 0.6219074))))
   (assert (element (formula ОксидЖелеза3) (mass (* (/ ?m0 1) 0.6219074))))
   (assert (element (formula ОксидЖелеза) (mass (* (/ ?m0 1) 0.6219074))))
   (assert (appendmessagehalt (str-cat "Боксит (" ?m0 ") -(0.6219074)> Al(OH)3 (" (* (/ ?m0 1) 0.6219074) ") + Fe2O3 (" (* (/ ?m0 1) 0.6219074) ") + FeO (" (* (/ ?m0 1) 0.6219074) ")")))
)


(defrule Магнетит_ОксидЖелеза_ОксидЖелеза3
   (declare (salience 40))
   (element (formula Магнетит) (mass ?m0))
   =>
   (assert (element (formula ОксидЖелеза) (mass (* (/ ?m0 1) 0.7001526))))
   (assert (element (formula ОксидЖелеза3) (mass (* (/ ?m0 1) 0.7001526))))
   (assert (appendmessagehalt (str-cat "Магнетит (" ?m0 ") -(0.7001526)> FeO (" (* (/ ?m0 1) 0.7001526) ") + Fe2O3 (" (* (/ ?m0 1) 0.7001526) ")")))
)


(defrule Малахит_Малахит
   (declare (salience 40))
   (element (formula Малахит) (mass ?m0))
   =>
   (assert (element (formula Малахит) (mass (* (/ ?m0 1) 0.479087))))
   (assert (appendmessagehalt (str-cat "Малахит (" ?m0 ") -(0.479087)> (CuOH)2CO3 (" (* (/ ?m0 1) 0.479087) ")")))
)


(defrule Соль_ХлоридНатрия
   (declare (salience 40))
   (element (formula Соль) (mass ?m0))
   =>
   (assert (element (formula ХлоридНатрия) (mass (* (/ ?m0 1) 0.7336369))))
   (assert (appendmessagehalt (str-cat "Соль (" ?m0 ") -(0.7336369)> NaCl (" (* (/ ?m0 1) 0.7336369) ")")))
)


(defrule Барит_СульфатБария
   (declare (salience 40))
   (element (formula Барит) (mass ?m0))
   =>
   (assert (element (formula СульфатБария) (mass (* (/ ?m0 1) 0.5368383))))
   (assert (appendmessagehalt (str-cat "Барит (" ?m0 ") -(0.5368383)> BaSO4 (" (* (/ ?m0 1) 0.5368383) ")")))
)


(defrule Пиролюзит_ОксидМарганца
   (declare (salience 40))
   (element (formula Пиролюзит) (mass ?m0))
   =>
   (assert (element (formula ОксидМарганца) (mass (* (/ ?m0 1) 0.7531601))))
   (assert (appendmessagehalt (str-cat "Пиролюзит (" ?m0 ") -(0.7531601)> MnO2 (" (* (/ ?m0 1) 0.7531601) ")")))
)


(defrule Фосфорит_ОксидФосфора
   (declare (salience 40))
   (element (formula Фосфорит) (mass ?m0))
   =>
   (assert (element (formula ОксидФосфора) (mass (* (/ ?m0 1) 0.9067911))))
   (assert (appendmessagehalt (str-cat "Фосфорит (" ?m0 ") -(0.9067911)> P4O10 (" (* (/ ?m0 1) 0.9067911) ")")))
)


(defrule Пирит_СульфидЖелеза
   (declare (salience 40))
   (element (formula Пирит) (mass ?m0))
   =>
   (assert (element (formula СульфидЖелеза) (mass (* (/ ?m0 1) 0.3695753))))
   (assert (appendmessagehalt (str-cat "Пирит (" ?m0 ") -(0.3695753)> FeS2 (" (* (/ ?m0 1) 0.3695753) ")")))
)


(defrule МедныйКолчедан_Халькопирит
   (declare (salience 40))
   (element (formula МедныйКолчедан) (mass ?m0))
   =>
   (assert (element (formula Халькопирит) (mass (* (/ ?m0 1) 0.716772))))
   (assert (appendmessagehalt (str-cat "МедныйКолчедан (" ?m0 ") -(0.716772)> CuFeS2 (" (* (/ ?m0 1) 0.716772) ")")))
)


(defrule Галенит_СульфидСвинца
   (declare (salience 40))
   (element (formula Галенит) (mass ?m0))
   =>
   (assert (element (formula СульфидСвинца) (mass (* (/ ?m0 1) 0.6379879))))
   (assert (appendmessagehalt (str-cat "Галенит (" ?m0 ") -(0.6379879)> PbS (" (* (/ ?m0 1) 0.6379879) ")")))
)


(defrule Уголь_Углерод
   (declare (salience 40))
   (element (formula Уголь) (mass ?m0))
   =>
   (assert (element (formula Углерод) (mass (* (/ ?m0 1) 0.9343171))))
   (assert (appendmessagehalt (str-cat "Уголь (" ?m0 ") -(0.9343171)> C (" (* (/ ?m0 1) 0.9343171) ")")))
)


(defrule Котик_Тепло
   (declare (salience 40))
   (element (formula Котик) (mass ?m0))
   =>
   (assert (element (formula Тепло) (mass (* (/ ?m0 1) 0.37113))))
   (assert (appendmessagehalt (str-cat "Котик (" ?m0 ") -(0.37113)> t (" (* (/ ?m0 1) 0.37113) ")")))
)


(defrule Кислород_Водород_ДигидрогенаМонооксид_Тепло
   (declare (salience 40))
   (element (formula Кислород) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   =>
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.6733148))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 2) 0.6733148))))
   (assert (appendmessagehalt (str-cat "O2 (" ?m0 ") + H2 (" ?m1 ") -(0.6733148)> H2O (" (* (/ (+ ?m0 ?m1) 2) 0.6733148) ") + t (" (* (/ (+ ?m0 ?m1) 2) 0.6733148) ")")))
)


(defrule Кислород_Тепло_Озон
   (declare (salience 40))
   (element (formula Кислород) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula Озон) (mass (* (/ (+ ?m0 ?m1) 2) 0.4006333))))
   (assert (appendmessagehalt (str-cat "O2 (" ?m0 ") + t (" ?m1 ") -(0.4006333)> O3 (" (* (/ (+ ?m0 ?m1) 2) 0.4006333) ")")))
)


(defrule Кислород_Свет_Озон
   (declare (salience 40))
   (element (formula Кислород) (mass ?m0))
   (element (formula Свет) (mass ?m1))
   =>
   (assert (element (formula Озон) (mass (* (/ (+ ?m0 ?m1) 2) 0.333946))))
   (assert (appendmessagehalt (str-cat "O2 (" ?m0 ") + hv (" ?m1 ") -(0.333946)> O3 (" (* (/ (+ ?m0 ?m1) 2) 0.333946) ")")))
)


(defrule Озон_Кислород_Тепло
   (declare (salience 40))
   (element (formula Озон) (mass ?m0))
   =>
   (assert (element (formula Кислород) (mass (* (/ ?m0 1) 0.5869571))))
   (assert (element (formula Тепло) (mass (* (/ ?m0 1) 0.5869571))))
   (assert (appendmessagehalt (str-cat "O3 (" ?m0 ") -(0.5869571)> O2 (" (* (/ ?m0 1) 0.5869571) ") + t (" (* (/ ?m0 1) 0.5869571) ")")))
)


(defrule ДигидрогенаМонооксид_Электролиз_Водород_Кислород
   (declare (salience 40))
   (element (formula ДигидрогенаМонооксид) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   =>
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.7985753))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 2) 0.7985753))))
   (assert (appendmessagehalt (str-cat "H2O (" ?m0 ") + e (" ?m1 ") -(0.7985753)> H2 (" (* (/ (+ ?m0 ?m1) 2) 0.7985753) ") + O2 (" (* (/ (+ ?m0 ?m1) 2) 0.7985753) ")")))
)


(defrule Сера_Кислород_МонооксидСеры_ДиоксидСеры_ТриоксидСеры
   (declare (salience 40))
   (element (formula Сера) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula МонооксидСеры) (mass (* (/ (+ ?m0 ?m1) 2) 0.3093747))))
   (assert (element (formula ДиоксидСеры) (mass (* (/ (+ ?m0 ?m1) 2) 0.3093747))))
   (assert (element (formula ТриоксидСеры) (mass (* (/ (+ ?m0 ?m1) 2) 0.3093747))))
   (assert (appendmessagehalt (str-cat "S (" ?m0 ") + O2 (" ?m1 ") -(0.3093747)> SO (" (* (/ (+ ?m0 ?m1) 2) 0.3093747) ") + SO2 (" (* (/ (+ ?m0 ?m1) 2) 0.3093747) ") + SO3 (" (* (/ (+ ?m0 ?m1) 2) 0.3093747) ")")))
)


(defrule Фтор_Кислород_ОксидФтора
   (declare (salience 40))
   (element (formula Фтор) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидФтора) (mass (* (/ (+ ?m0 ?m1) 2) 0.5987902))))
   (assert (appendmessagehalt (str-cat "F2 (" ?m0 ") + O2 (" ?m1 ") -(0.5987902)> F2O (" (* (/ (+ ?m0 ?m1) 2) 0.5987902) ")")))
)


(defrule Азот_Кислород_ОксидАзота1_ОксидАзота2_ОксидАзота3_ОксидАзота4_ОксидАзота5
   (declare (salience 40))
   (element (formula Азот) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидАзота1) (mass (* (/ (+ ?m0 ?m1) 2) 0.4950001))))
   (assert (element (formula ОксидАзота2) (mass (* (/ (+ ?m0 ?m1) 2) 0.4950001))))
   (assert (element (formula ОксидАзота3) (mass (* (/ (+ ?m0 ?m1) 2) 0.4950001))))
   (assert (element (formula ОксидАзота4) (mass (* (/ (+ ?m0 ?m1) 2) 0.4950001))))
   (assert (element (formula ОксидАзота5) (mass (* (/ (+ ?m0 ?m1) 2) 0.4950001))))
   (assert (appendmessagehalt (str-cat "N2 (" ?m0 ") + O2 (" ?m1 ") -(0.4950001)> N2O (" (* (/ (+ ?m0 ?m1) 2) 0.4950001) ") + NO (" (* (/ (+ ?m0 ?m1) 2) 0.4950001) ") + N2O3 (" (* (/ (+ ?m0 ?m1) 2) 0.4950001) ") + NO2 (" (* (/ (+ ?m0 ?m1) 2) 0.4950001) ") + N2O5 (" (* (/ (+ ?m0 ?m1) 2) 0.4950001) ")")))
)


(defrule ОксидАзота2_Кислород_ОксидАзота4
   (declare (salience 40))
   (element (formula ОксидАзота2) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидАзота4) (mass (* (/ (+ ?m0 ?m1) 2) 0.5377659))))
   (assert (appendmessagehalt (str-cat "NO (" ?m0 ") + O2 (" ?m1 ") -(0.5377659)> NO2 (" (* (/ (+ ?m0 ?m1) 2) 0.5377659) ")")))
)


(defrule Углерод_Кислород_УгарныйГаз_УглекислыйГаз_Тепло
   (declare (salience 40))
   (element (formula Углерод) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula УгарныйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.6838352))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.6838352))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 2) 0.6838352))))
   (assert (appendmessagehalt (str-cat "C (" ?m0 ") + O2 (" ?m1 ") -(0.6838352)> CO (" (* (/ (+ ?m0 ?m1) 2) 0.6838352) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.6838352) ") + t (" (* (/ (+ ?m0 ?m1) 2) 0.6838352) ")")))
)


(defrule Натрий_Кислород_ОксидНатрия_Тепло
   (declare (salience 40))
   (element (formula Натрий) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3887339))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 2) 0.3887339))))
   (assert (appendmessagehalt (str-cat "Na (" ?m0 ") + O2 (" ?m1 ") -(0.3887339)> NaO (" (* (/ (+ ?m0 ?m1) 2) 0.3887339) ") + t (" (* (/ (+ ?m0 ?m1) 2) 0.3887339) ")")))
)


(defrule Калий_Кислород_ОксидКалия_Тепло
   (declare (salience 40))
   (element (formula Калий) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.4260599))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 2) 0.4260599))))
   (assert (appendmessagehalt (str-cat "K (" ?m0 ") + O2 (" ?m1 ") -(0.4260599)> K2O (" (* (/ (+ ?m0 ?m1) 2) 0.4260599) ") + t (" (* (/ (+ ?m0 ?m1) 2) 0.4260599) ")")))
)


(defrule ТриоксидСеры_ДигидрогенаМонооксид_СернаяКислота
   (declare (salience 40))
   (element (formula ТриоксидСеры) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula СернаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.7351391))))
   (assert (appendmessagehalt (str-cat "SO3 (" ?m0 ") + H2O (" ?m1 ") -(0.7351391)> H2SO4 (" (* (/ (+ ?m0 ?m1) 2) 0.7351391) ")")))
)


(defrule СернаяКислота_Электролиз_ПероксодисернаяКислота_Водород
   (declare (salience 40))
   (element (formula СернаяКислота) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   =>
   (assert (element (formula ПероксодисернаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.4090928))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.4090928))))
   (assert (appendmessagehalt (str-cat "H2SO4 (" ?m0 ") + e (" ?m1 ") -(0.4090928)> H2S2O8 (" (* (/ (+ ?m0 ?m1) 2) 0.4090928) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.4090928) ")")))
)


(defrule ПероксодисернаяКислота_ДигидрогенаМонооксид_ПероксидВодорода_СернаяКислота
   (declare (salience 40))
   (element (formula ПероксодисернаяКислота) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ПероксидВодорода) (mass (* (/ (+ ?m0 ?m1) 2) 0.4312044))))
   (assert (element (formula СернаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.4312044))))
   (assert (appendmessagehalt (str-cat "H2S2O8 (" ?m0 ") + H2O (" ?m1 ") -(0.4312044)> H2O2 (" (* (/ (+ ?m0 ?m1) 2) 0.4312044) ") + H2SO4 (" (* (/ (+ ?m0 ?m1) 2) 0.4312044) ")")))
)


(defrule СолянаяКислота_ДиоксидСеры_ХлорсульфоноваяКислота
   (declare (salience 40))
   (element (formula СолянаяКислота) (mass ?m0))
   (element (formula ДиоксидСеры) (mass ?m1))
   =>
   (assert (element (formula ХлорсульфоноваяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.3955064))))
   (assert (appendmessagehalt (str-cat "HCl (" ?m0 ") + SO2 (" ?m1 ") -(0.3955064)> HSO3Cl (" (* (/ (+ ?m0 ?m1) 2) 0.3955064) ")")))
)


(defrule Водород_Хлор_СолянаяКислота
   (declare (salience 40))
   (element (formula Водород) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.804376))))
   (assert (appendmessagehalt (str-cat "H2 (" ?m0 ") + Cl2 (" ?m1 ") -(0.804376)> HCl (" (* (/ (+ ?m0 ?m1) 2) 0.804376) ")")))
)


(defrule ГидроксидНатрия_Хлор_ХлоридНатрия_ГипохлоритНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидНатрия) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7117549))))
   (assert (element (formula ГипохлоритНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7117549))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.7117549))))
   (assert (appendmessagehalt (str-cat "NaOH (" ?m0 ") + Cl2 (" ?m1 ") -(0.7117549)> NaCl (" (* (/ (+ ?m0 ?m1) 2) 0.7117549) ") + NaOCl (" (* (/ (+ ?m0 ?m1) 2) 0.7117549) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.7117549) ")")))
)


(defrule Натрий_ДигидрогенаМонооксид_ГидроксидНатрия_Водород
   (declare (salience 40))
   (element (formula Натрий) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.8730323))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.8730323))))
   (assert (appendmessagehalt (str-cat "Na (" ?m0 ") + H2O (" ?m1 ") -(0.8730323)> NaOH (" (* (/ (+ ?m0 ?m1) 2) 0.8730323) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.8730323) ")")))
)


(defrule ХлоридНатрия_СернаяКислота_ГидросульфатНатрия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридНатрия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula ГидросульфатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.8741518))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.8741518))))
   (assert (appendmessagehalt (str-cat "NaCl (" ?m0 ") + H2SO4 (" ?m1 ") -(0.8741518)> NaHSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.8741518) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.8741518) ")")))
)


(defrule Калий_ДигидрогенаМонооксид_ГидроксидКалия
   (declare (salience 40))
   (element (formula Калий) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3151508))))
   (assert (appendmessagehalt (str-cat "K (" ?m0 ") + H2O (" ?m1 ") -(0.3151508)> KOH (" (* (/ (+ ?m0 ?m1) 2) 0.3151508) ")")))
)


(defrule АзотнаяКислота_Свет_ОксидАзота2_ДигидрогенаМонооксид_Кислород
   (declare (salience 40))
   (element (formula АзотнаяКислота) (mass ?m0))
   (element (formula Свет) (mass ?m1))
   =>
   (assert (element (formula ОксидАзота2) (mass (* (/ (+ ?m0 ?m1) 2) 0.8050611))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.8050611))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 2) 0.8050611))))
   (assert (appendmessagehalt (str-cat "HNO3 (" ?m0 ") + hv (" ?m1 ") -(0.8050611)> NO (" (* (/ (+ ?m0 ?m1) 2) 0.8050611) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.8050611) ") + O2 (" (* (/ (+ ?m0 ?m1) 2) 0.8050611) ")")))
)


(defrule Метан_Кислород_ОксидАзота2_ДигидрогенаМонооксид_Тепло
   (declare (salience 40))
   (element (formula Метан) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидАзота2) (mass (* (/ (+ ?m0 ?m1) 2) 0.5053139))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.5053139))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 2) 0.5053139))))
   (assert (appendmessagehalt (str-cat "NH3 (" ?m0 ") + O2 (" ?m1 ") -(0.5053139)> NO (" (* (/ (+ ?m0 ?m1) 2) 0.5053139) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.5053139) ") + t (" (* (/ (+ ?m0 ?m1) 2) 0.5053139) ")")))
)


(defrule ОксидАзота4_Кислород_ДигидрогенаМонооксид_АзотнаяКислота_Тепло
   (declare (salience 40))
   (element (formula ОксидАзота4) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula ДигидрогенаМонооксид) (mass ?m2))
   =>
   (assert (element (formula АзотнаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3529247))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3529247))))
   (assert (appendmessagehalt (str-cat "NO2 (" ?m0 ") + O2 (" ?m1 ") + H2O (" ?m2 ") -(0.3529247)> HNO3 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3529247) ") + t (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3529247) ")")))
)


(defrule Азот_Водород_Метан_Тепло
   (declare (salience 40))
   (element (formula Азот) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   =>
   (assert (element (formula Метан) (mass (* (/ (+ ?m0 ?m1) 2) 0.47122))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 2) 0.47122))))
   (assert (appendmessagehalt (str-cat "N2 (" ?m0 ") + H2 (" ?m1 ") -(0.47122)> NH3 (" (* (/ (+ ?m0 ?m1) 2) 0.47122) ") + t (" (* (/ (+ ?m0 ?m1) 2) 0.47122) ")")))
)


(defrule Метан_Тепло_Азот_Водород
   (declare (salience 40))
   (element (formula Метан) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula Азот) (mass (* (/ (+ ?m0 ?m1) 2) 0.7393899))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.7393899))))
   (assert (appendmessagehalt (str-cat "NH3 (" ?m0 ") + t (" ?m1 ") -(0.7393899)> N2 (" (* (/ (+ ?m0 ?m1) 2) 0.7393899) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.7393899) ")")))
)


(defrule ДигидрогенаМонооксид_УглекислыйГаз_УгольнаяКислота
   (declare (salience 40))
   (element (formula ДигидрогенаМонооксид) (mass ?m0))
   (element (formula УглекислыйГаз) (mass ?m1))
   =>
   (assert (element (formula УгольнаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.3978693))))
   (assert (appendmessagehalt (str-cat "H2O (" ?m0 ") + CO2 (" ?m1 ") -(0.3978693)> H2CO3 (" (* (/ (+ ?m0 ?m1) 2) 0.3978693) ")")))
)


(defrule УгольнаяКислота_ДигидрогенаМонооксид_УглекислыйГаз
   (declare (salience 40))
   (element (formula УгольнаяКислота) (mass ?m0))
   =>
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ ?m0 1) 0.4734537))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ ?m0 1) 0.4734537))))
   (assert (appendmessagehalt (str-cat "H2CO3 (" ?m0 ") -(0.4734537)> H2O (" (* (/ ?m0 1) 0.4734537) ") + CO2 (" (* (/ ?m0 1) 0.4734537) ")")))
)


(defrule КарбонатНатрия_СолянаяКислота_ХлоридНатрия_УгольнаяКислота
   (declare (salience 40))
   (element (formula КарбонатНатрия) (mass ?m0))
   (element (formula СолянаяКислота) (mass ?m1))
   =>
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.458553))))
   (assert (element (formula УгольнаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.458553))))
   (assert (appendmessagehalt (str-cat "Na2CO3 (" ?m0 ") + HCl (" ?m1 ") -(0.458553)> NaCl (" (* (/ (+ ?m0 ?m1) 2) 0.458553) ") + H2CO3 (" (* (/ (+ ?m0 ?m1) 2) 0.458553) ")")))
)


(defrule СиликатНатрия_СолянаяКислота_МетакремниеваяКислота_ХлоридНатрия
   (declare (salience 40))
   (element (formula СиликатНатрия) (mass ?m0))
   (element (formula СолянаяКислота) (mass ?m1))
   =>
   (assert (element (formula МетакремниеваяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.3404272))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3404272))))
   (assert (appendmessagehalt (str-cat "Na2SiO3 (" ?m0 ") + HCl (" ?m1 ") -(0.3404272)> H2SiO3 (" (* (/ (+ ?m0 ?m1) 2) 0.3404272) ") + NaCl (" (* (/ (+ ?m0 ?m1) 2) 0.3404272) ")")))
)


(defrule Дихлорсилан_ДигидрогенаМонооксид_СернистаяКислота_СолянаяКислота_Водород
   (declare (salience 40))
   (element (formula Дихлорсилан) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula СернистаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.623792))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.623792))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.623792))))
   (assert (appendmessagehalt (str-cat "SiH2Cl2 (" ?m0 ") + H2O (" ?m1 ") -(0.623792)> H2SO3 (" (* (/ (+ ?m0 ?m1) 2) 0.623792) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.623792) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.623792) ")")))
)


(defrule ОксидАзота3_ДигидрогенаМонооксид_АзотистаяКислота
   (declare (salience 40))
   (element (formula ОксидАзота3) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula АзотистаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.9212831))))
   (assert (appendmessagehalt (str-cat "N2O3 (" ?m0 ") + H2O (" ?m1 ") -(0.9212831)> HNO2 (" (* (/ (+ ?m0 ?m1) 2) 0.9212831) ")")))
)


(defrule ОксидАзота4_ДигидрогенаМонооксид_АзотнаяКислота_АзотистаяКислота
   (declare (salience 40))
   (element (formula ОксидАзота4) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula АзотнаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.8979645))))
   (assert (element (formula АзотистаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.8979645))))
   (assert (appendmessagehalt (str-cat "NO2 (" ?m0 ") + H2O (" ?m1 ") -(0.8979645)> HNO3 (" (* (/ (+ ?m0 ?m1) 2) 0.8979645) ") + HNO2 (" (* (/ (+ ?m0 ?m1) 2) 0.8979645) ")")))
)


(defrule Фосфор_АзотнаяКислота_ДигидрогенаМонооксид_ОртофосфорнаяКислота_ОксидАзота2
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula АзотнаяКислота) (mass ?m1))
   (element (formula ДигидрогенаМонооксид) (mass ?m2))
   =>
   (assert (element (formula ОртофосфорнаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4072093))))
   (assert (element (formula ОксидАзота2) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4072093))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + HNO3 (" ?m1 ") + H2O (" ?m2 ") -(0.4072093)> H3PO4 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4072093) ") + NO (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4072093) ")")))
)


(defrule БелыйФосфор_Кислород_Тепло_ОксидФосфора
   (declare (salience 40))
   (element (formula БелыйФосфор) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидФосфора) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7058429))))
   (assert (appendmessagehalt (str-cat "P4 (" ?m0 ") + O2 (" ?m1 ") + t (" ?m2 ") -(0.7058429)> P4O10 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7058429) ")")))
)


(defrule ОксидФосфора_ДигидрогенаМонооксид_ОртофосфорнаяКислота
   (declare (salience 40))
   (element (formula ОксидФосфора) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ОртофосфорнаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.5470245))))
   (assert (appendmessagehalt (str-cat "P4O10 (" ?m0 ") + H2O (" ?m1 ") -(0.5470245)> H3PO4 (" (* (/ (+ ?m0 ?m1) 2) 0.5470245) ")")))
)


(defrule ОксидФосфора3_ДигидрогенаМонооксид_ФосфористаяКислота
   (declare (salience 40))
   (element (formula ОксидФосфора3) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ФосфористаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.607751))))
   (assert (appendmessagehalt (str-cat "P2O3 (" ?m0 ") + H2O (" ?m1 ") -(0.607751)> H3PO3 (" (* (/ (+ ?m0 ?m1) 2) 0.607751) ")")))
)


(defrule ХлоридФосфора_ДигидрогенаМонооксид_ФосфористаяКислота_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридФосфора) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ФосфористаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.9278327))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.9278327))))
   (assert (appendmessagehalt (str-cat "PCl3 (" ?m0 ") + H2O (" ?m1 ") -(0.9278327)> H3PO3 (" (* (/ (+ ?m0 ?m1) 2) 0.9278327) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.9278327) ")")))
)


(defrule ГидрофосфатКалия_СолянаяКислота_ХлоридКалия_ФосфористаяКислота
   (declare (salience 40))
   (element (formula ГидрофосфатКалия) (mass ?m0))
   (element (formula СолянаяКислота) (mass ?m1))
   =>
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.566823))))
   (assert (element (formula ФосфористаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.566823))))
   (assert (appendmessagehalt (str-cat "K2HPO3 (" ?m0 ") + HCl (" ?m1 ") -(0.566823)> KCl (" (* (/ (+ ?m0 ?m1) 2) 0.566823) ") + H3PO3 (" (* (/ (+ ?m0 ?m1) 2) 0.566823) ")")))
)


(defrule ОксидХрома_ДигидрогенаМонооксид_ХромоваяКислота_ДихромоваяКислота
   (declare (salience 40))
   (element (formula ОксидХрома) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ХромоваяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.4950179))))
   (assert (element (formula ДихромоваяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.4950179))))
   (assert (appendmessagehalt (str-cat "CrO3 (" ?m0 ") + H2O (" ?m1 ") -(0.4950179)> H2CrO4 (" (* (/ (+ ?m0 ?m1) 2) 0.4950179) ") + H2Cr2O7 (" (* (/ (+ ?m0 ?m1) 2) 0.4950179) ")")))
)


(defrule Хлор_ДигидрогенаМонооксид_ХлорноватистаяКислота_СолянаяКислота
   (declare (salience 40))
   (element (formula Хлор) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ХлорноватистаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.6273982))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.6273982))))
   (assert (appendmessagehalt (str-cat "Cl2 (" ?m0 ") + H2O (" ?m1 ") -(0.6273982)> HClO (" (* (/ (+ ?m0 ?m1) 2) 0.6273982) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.6273982) ")")))
)


(defrule ОксидХлора_ДигидрогенаМонооксид_ХлорноватистаяКислота
   (declare (salience 40))
   (element (formula ОксидХлора) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ХлорноватистаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.6874095))))
   (assert (appendmessagehalt (str-cat "Cl2O (" ?m0 ") + H2O (" ?m1 ") -(0.6874095)> HClO (" (* (/ (+ ?m0 ?m1) 2) 0.6874095) ")")))
)


(defrule ОксидХлора_ПероксидВодорода_ГидроксидНатрия_ХлоритНатрия_Кислород_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидХлора) (mass ?m0))
   (element (formula ПероксидВодорода) (mass ?m1))
   (element (formula ГидроксидНатрия) (mass ?m2))
   =>
   (assert (element (formula ХлоритНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3575487))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3575487))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3575487))))
   (assert (appendmessagehalt (str-cat "ClO2 (" ?m0 ") + H2O2 (" ?m1 ") + NaOH (" ?m2 ") -(0.3575487)> NaClO2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3575487) ") + O2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3575487) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3575487) ")")))
)


(defrule ГипохлоритБария_СернаяКислота_СульфатБария_ХлористаяКислота
   (declare (salience 40))
   (element (formula ГипохлоритБария) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula СульфатБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.8880722))))
   (assert (element (formula ХлористаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.8880722))))
   (assert (appendmessagehalt (str-cat "Ba(ClO2)2 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.8880722)> BaSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.8880722) ") + HClO2 (" (* (/ (+ ?m0 ?m1) 2) 0.8880722) ")")))
)


(defrule ХлоратБария_СернаяКислота_СульфатБария_ХлорноватаяКислота
   (declare (salience 40))
   (element (formula ХлоратБария) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula СульфатБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.6114187))))
   (assert (element (formula ХлорноватаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.6114187))))
   (assert (appendmessagehalt (str-cat "Ba(ClO3)2 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.6114187)> BaSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.6114187) ") + HClO3 (" (* (/ (+ ?m0 ?m1) 2) 0.6114187) ")")))
)


(defrule ПерхлоратКалия_СернаяКислота_ГидросульфатКалия_ХлорнаяКислота
   (declare (salience 40))
   (element (formula ПерхлоратКалия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula ГидросульфатКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.353027))))
   (assert (element (formula ХлорнаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.353027))))
   (assert (appendmessagehalt (str-cat "KClO4 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.353027)> KHSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.353027) ") + HClO4 (" (* (/ (+ ?m0 ?m1) 2) 0.353027) ")")))
)


(defrule ПерманганатБария_СернаяКислота_МарганцоваяКислота_СульфатБария
   (declare (salience 40))
   (element (formula ПерманганатБария) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula МарганцоваяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.9484977))))
   (assert (element (formula СульфатБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.9484977))))
   (assert (appendmessagehalt (str-cat "Ba(MnO4)2 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.9484977)> HMnO4 (" (* (/ (+ ?m0 ?m1) 2) 0.9484977) ") + BaSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.9484977) ")")))
)


(defrule ОксидМарганца_ДигидрогенаМонооксид_МарганцоваяКислота
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula МарганцоваяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.4277454))))
   (assert (appendmessagehalt (str-cat "Mn2O7 (" ?m0 ") + H2O (" ?m1 ") -(0.4277454)> HMnO4 (" (* (/ (+ ?m0 ?m1) 2) 0.4277454) ")")))
)


(defrule СульфатНатрия_Углерод_СульфидНатрия_УглекислыйГаз
   (declare (salience 40))
   (element (formula СульфатНатрия) (mass ?m0))
   (element (formula Углерод) (mass ?m1))
   =>
   (assert (element (formula СульфидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.6219557))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.6219557))))
   (assert (appendmessagehalt (str-cat "Na2SO4 (" ?m0 ") + C (" ?m1 ") -(0.6219557)> Na2S (" (* (/ (+ ?m0 ?m1) 2) 0.6219557) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.6219557) ")")))
)


(defrule СульфидНатрия_КарбонатКальция_КарбонатНатрия_СульфидКальция
   (declare (salience 40))
   (element (formula СульфидНатрия) (mass ?m0))
   (element (formula КарбонатКальция) (mass ?m1))
   =>
   (assert (element (formula КарбонатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.8112847))))
   (assert (element (formula СульфидКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.8112847))))
   (assert (appendmessagehalt (str-cat "Na2S (" ?m0 ") + CaCO3 (" ?m1 ") -(0.8112847)> Na2CO3 (" (* (/ (+ ?m0 ?m1) 2) 0.8112847) ") + CaS (" (* (/ (+ ?m0 ?m1) 2) 0.8112847) ")")))
)


(defrule ХлоридНатрия_СернаяКислота_СульфатНатрия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридНатрия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula СульфатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.5151993))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.5151993))))
   (assert (appendmessagehalt (str-cat "NaCl (" ?m0 ") + H2SO4 (" ?m1 ") -(0.5151993)> Na2SO4 (" (* (/ (+ ?m0 ?m1) 2) 0.5151993) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.5151993) ")")))
)


(defrule Метан_УглекислыйГаз_ДигидрогенаМонооксид_ХлоридНатрия_ГидрокарбонатНатрия_ХлоридАммония
   (declare (salience 40))
   (element (formula Метан) (mass ?m0))
   (element (formula УглекислыйГаз) (mass ?m1))
   (element (formula ДигидрогенаМонооксид) (mass ?m2))
   (element (formula ХлоридНатрия) (mass ?m3))
   =>
   (assert (element (formula ГидрокарбонатНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.3050171))))
   (assert (element (formula ХлоридАммония) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.3050171))))
   (assert (appendmessagehalt (str-cat "NH3 (" ?m0 ") + CO2 (" ?m1 ") + H2O (" ?m2 ") + NaCl (" ?m3 ") -(0.3050171)> NaHCO3 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.3050171) ") + HN4Cl (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.3050171) ")")))
)


(defrule ГидрокарбонатНатрия_Тепло_КарбонатНатрия_ДигидрогенаМонооксид_УглекислыйГаз
   (declare (salience 40))
   (element (formula ГидрокарбонатНатрия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula КарбонатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7149557))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.7149557))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.7149557))))
   (assert (appendmessagehalt (str-cat "NaHCO3 (" ?m0 ") + t (" ?m1 ") -(0.7149557)> Na2CO3 (" (* (/ (+ ?m0 ?m1) 2) 0.7149557) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.7149557) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.7149557) ")")))
)


(defrule ОксидКремния_ГидроксидНатрия_СиликатНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидКремния) (mass ?m0))
   (element (formula ГидроксидНатрия) (mass ?m1))
   =>
   (assert (element (formula СиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3601653))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.3601653))))
   (assert (appendmessagehalt (str-cat "SiO2 (" ?m0 ") + NaOH (" ?m1 ") -(0.3601653)> Na2SiO3 (" (* (/ (+ ?m0 ?m1) 2) 0.3601653) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.3601653) ")")))
)


(defrule ОксидКремния_КарбонатНатрия_СиликатНатрия_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидКремния) (mass ?m0))
   (element (formula КарбонатНатрия) (mass ?m1))
   =>
   (assert (element (formula СиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3559792))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.3559792))))
   (assert (appendmessagehalt (str-cat "SiO2 (" ?m0 ") + Na2CO3 (" ?m1 ") -(0.3559792)> Na2SiO3 (" (* (/ (+ ?m0 ?m1) 2) 0.3559792) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.3559792) ")")))
)


(defrule ОртосиликатНатрия_Тепло_СиликатНатрия_ОксидНатрия
   (declare (salience 40))
   (element (formula ОртосиликатНатрия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula СиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.8182536))))
   (assert (element (formula ОксидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.8182536))))
   (assert (appendmessagehalt (str-cat "Na4SiO4 (" ?m0 ") + t (" ?m1 ") -(0.8182536)> Na2SiO3 (" (* (/ (+ ?m0 ?m1) 2) 0.8182536) ") + Na2O (" (* (/ (+ ?m0 ?m1) 2) 0.8182536) ")")))
)


(defrule СлоридАммония_ГидроксидНатрия_Метан_ХлоридНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СлоридАммония) (mass ?m0))
   (element (formula ГидроксидНатрия) (mass ?m1))
   =>
   (assert (element (formula Метан) (mass (* (/ (+ ?m0 ?m1) 2) 0.8453194))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.8453194))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.8453194))))
   (assert (appendmessagehalt (str-cat "NH4Cl (" ?m0 ") + NaOH (" ?m1 ") -(0.8453194)> NH3 (" (* (/ (+ ?m0 ?m1) 2) 0.8453194) ") + NaCl (" (* (/ (+ ?m0 ?m1) 2) 0.8453194) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.8453194) ")")))
)


(defrule МетафосфорнаяКислота_Углерод_БелыйФосфор_ДигидрогенаМонооксид_УгарныйГаз
   (declare (salience 40))
   (element (formula МетафосфорнаяКислота) (mass ?m0))
   (element (formula Углерод) (mass ?m1))
   =>
   (assert (element (formula БелыйФосфор) (mass (* (/ (+ ?m0 ?m1) 2) 0.9310213))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.9310213))))
   (assert (element (formula УгарныйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.9310213))))
   (assert (appendmessagehalt (str-cat "HPO3 (" ?m0 ") + C (" ?m1 ") -(0.9310213)> P4 (" (* (/ (+ ?m0 ?m1) 2) 0.9310213) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.9310213) ") + CO (" (* (/ (+ ?m0 ?m1) 2) 0.9310213) ")")))
)


(defrule Фосфор_Кислород_ОксидФосфора5_ОксидФосфора3
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидФосфора5) (mass (* (/ (+ ?m0 ?m1) 2) 0.4157371))))
   (assert (element (formula ОксидФосфора3) (mass (* (/ (+ ?m0 ?m1) 2) 0.4157371))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + O2 (" ?m1 ") -(0.4157371)> P2O5 (" (* (/ (+ ?m0 ?m1) 2) 0.4157371) ") + P2O3 (" (* (/ (+ ?m0 ?m1) 2) 0.4157371) ")")))
)


(defrule Фосфор_Кальций_ФосфидКальция
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula Кальций) (mass ?m1))
   =>
   (assert (element (formula ФосфидКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.3591853))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + Ca (" ?m1 ") -(0.3591853)> Ca3P2 (" (* (/ (+ ?m0 ?m1) 2) 0.3591853) ")")))
)


(defrule Фосфор_Сера_СульфидФосфора
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula Сера) (mass ?m1))
   =>
   (assert (element (formula СульфидФосфора) (mass (* (/ (+ ?m0 ?m1) 2) 0.8615053))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + S (" ?m1 ") -(0.8615053)> P2S3 (" (* (/ (+ ?m0 ?m1) 2) 0.8615053) ")")))
)


(defrule Фосфор_Хлор_ХлоридФосфора_ХлоридФосфора
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ХлоридФосфора) (mass (* (/ (+ ?m0 ?m1) 2) 0.4253365))))
   (assert (element (formula ХлоридФосфора) (mass (* (/ (+ ?m0 ?m1) 2) 0.4253365))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + Cl2 (" ?m1 ") -(0.4253365)> PCl3 (" (* (/ (+ ?m0 ?m1) 2) 0.4253365) ") + PCl5 (" (* (/ (+ ?m0 ?m1) 2) 0.4253365) ")")))
)


(defrule Фосфор_ДигидрогенаМонооксид_Тепло_Фосфин_ОртофосфорнаяКислота
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Фосфин) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3364471))))
   (assert (element (formula ОртофосфорнаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3364471))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + H2O (" ?m1 ") + t (" ?m2 ") -(0.3364471)> PH3 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3364471) ") + H3PO4 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3364471) ")")))
)


(defrule Фосфор_ДигидрогенаМонооксид_Тепло_ОртофосфорнаяКислота_Водород
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОртофосфорнаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4973387))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4973387))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + H2O (" ?m1 ") + t (" ?m2 ") -(0.4973387)> H3PO4 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4973387) ") + H2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4973387) ")")))
)


(defrule БелыйФосфор_Тепло_Фосфор
   (declare (salience 40))
   (element (formula БелыйФосфор) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula Фосфор) (mass (* (/ (+ ?m0 ?m1) 2) 0.3600433))))
   (assert (appendmessagehalt (str-cat "P4 (" ?m0 ") + t (" ?m1 ") -(0.3600433)> P (" (* (/ (+ ?m0 ?m1) 2) 0.3600433) ")")))
)


(defrule БелыйФосфор_Свет_Фосфор
   (declare (salience 40))
   (element (formula БелыйФосфор) (mass ?m0))
   (element (formula Свет) (mass ?m1))
   =>
   (assert (element (formula Фосфор) (mass (* (/ (+ ?m0 ?m1) 2) 0.4174509))))
   (assert (appendmessagehalt (str-cat "P4 (" ?m0 ") + hv (" ?m1 ") -(0.4174509)> P (" (* (/ (+ ?m0 ?m1) 2) 0.4174509) ")")))
)


(defrule БелыйФосфор_ОксидАзота1_ОксидФосфора_Азот
   (declare (salience 40))
   (element (formula БелыйФосфор) (mass ?m0))
   (element (formula ОксидАзота1) (mass ?m1))
   =>
   (assert (element (formula ОксидФосфора) (mass (* (/ (+ ?m0 ?m1) 2) 0.4780955))))
   (assert (element (formula Азот) (mass (* (/ (+ ?m0 ?m1) 2) 0.4780955))))
   (assert (appendmessagehalt (str-cat "P4 (" ?m0 ") + N2O (" ?m1 ") -(0.4780955)> P4O5 (" (* (/ (+ ?m0 ?m1) 2) 0.4780955) ") + N2 (" (* (/ (+ ?m0 ?m1) 2) 0.4780955) ")")))
)


(defrule БелыйФосфор_УглекислыйГаз_ОксидФосфора_УгарныйГаз
   (declare (salience 40))
   (element (formula БелыйФосфор) (mass ?m0))
   (element (formula УглекислыйГаз) (mass ?m1))
   =>
   (assert (element (formula ОксидФосфора) (mass (* (/ (+ ?m0 ?m1) 2) 0.6279298))))
   (assert (element (formula УгарныйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.6279298))))
   (assert (appendmessagehalt (str-cat "P4 (" ?m0 ") + CO2 (" ?m1 ") -(0.6279298)> P4O5 (" (* (/ (+ ?m0 ?m1) 2) 0.6279298) ") + CO (" (* (/ (+ ?m0 ?m1) 2) 0.6279298) ")")))
)


(defrule ДихроматНатрия_СернаяКислота_ОксидХрома_СульфатНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ДихроматНатрия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula ОксидХрома) (mass (* (/ (+ ?m0 ?m1) 2) 0.65325))))
   (assert (element (formula СульфатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.65325))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.65325))))
   (assert (appendmessagehalt (str-cat "Na2Cr2O7 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.65325)> CrO3 (" (* (/ (+ ?m0 ?m1) 2) 0.65325) ") + Na2SO4 (" (* (/ (+ ?m0 ?m1) 2) 0.65325) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.65325) ")")))
)


(defrule ОксидРтути_Хлор_ГипохлоридРтути_ОксидХлора
   (declare (salience 40))
   (element (formula ОксидРтути) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ГипохлоридРтути) (mass (* (/ (+ ?m0 ?m1) 2) 0.8341799))))
   (assert (element (formula ОксидХлора) (mass (* (/ (+ ?m0 ?m1) 2) 0.8341799))))
   (assert (appendmessagehalt (str-cat "HgO (" ?m0 ") + Cl2 (" ?m1 ") -(0.8341799)> Hg2OCl2 (" (* (/ (+ ?m0 ?m1) 2) 0.8341799) ") + Cl2O (" (* (/ (+ ?m0 ?m1) 2) 0.8341799) ")")))
)


(defrule ОксидРтути_Хлор_ХлоридРтути_ОксидХлора
   (declare (salience 40))
   (element (formula ОксидРтути) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ХлоридРтути) (mass (* (/ (+ ?m0 ?m1) 2) 0.7377554))))
   (assert (element (formula ОксидХлора) (mass (* (/ (+ ?m0 ?m1) 2) 0.7377554))))
   (assert (appendmessagehalt (str-cat "HgO (" ?m0 ") + Cl2 (" ?m1 ") -(0.7377554)> HgCl2 (" (* (/ (+ ?m0 ?m1) 2) 0.7377554) ") + Cl2O (" (* (/ (+ ?m0 ?m1) 2) 0.7377554) ")")))
)


(defrule Хлор_КарбонатНатрия_ДигидрогенаМонооксид_ГидрокарбонатНатрия_ХлоридНатрия_ОксидХлора
   (declare (salience 40))
   (element (formula Хлор) (mass ?m0))
   (element (formula КарбонатНатрия) (mass ?m1))
   (element (formula ДигидрогенаМонооксид) (mass ?m2))
   =>
   (assert (element (formula ГидрокарбонатНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8265433))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8265433))))
   (assert (element (formula ОксидХлора) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8265433))))
   (assert (appendmessagehalt (str-cat "Cl2 (" ?m0 ") + Na2CO3 (" ?m1 ") + H2O (" ?m2 ") -(0.8265433)> NaHCO3 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8265433) ") + NaCl (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8265433) ") + Cl2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8265433) ")")))
)


(defrule ХлоратКалия_ЩавелеваяКислота_ОксидХлора_КарбонатКалия_УглекислыйГаз_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ХлоратКалия) (mass ?m0))
   (element (formula ЩавелеваяКислота) (mass ?m1))
   =>
   (assert (element (formula ОксидХлора) (mass (* (/ (+ ?m0 ?m1) 2) 0.4449319))))
   (assert (element (formula КарбонатКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.4449319))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.4449319))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.4449319))))
   (assert (appendmessagehalt (str-cat "KClO3 (" ?m0 ") + H2C2O4 (" ?m1 ") -(0.4449319)> ClO2 (" (* (/ (+ ?m0 ?m1) 2) 0.4449319) ") + K2CO3 (" (* (/ (+ ?m0 ?m1) 2) 0.4449319) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.4449319) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.4449319) ")")))
)


(defrule ХлоратНатрия_ДиоксидСеры_СернаяКислота_ГидросульфатНатрия_ОксидХлора
   (declare (salience 40))
   (element (formula ХлоратНатрия) (mass ?m0))
   (element (formula ДиоксидСеры) (mass ?m1))
   (element (formula СернаяКислота) (mass ?m2))
   =>
   (assert (element (formula ГидросульфатНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6780143))))
   (assert (element (formula ОксидХлора) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6780143))))
   (assert (appendmessagehalt (str-cat "NaClO3 (" ?m0 ") + SO2 (" ?m1 ") + H2SO4 (" ?m2 ") -(0.6780143)> NaHSO4 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6780143) ") + ClO2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6780143) ")")))
)


(defrule ГидроксидБария_Хлор_ГипохлоритБария_ХлоридБария_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидБария) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ГипохлоритБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.5467536))))
   (assert (element (formula ХлоридБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.5467536))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.5467536))))
   (assert (appendmessagehalt (str-cat "Ba(OH)2 (" ?m0 ") + Cl2 (" ?m1 ") -(0.5467536)> Ba(ClO)2 (" (* (/ (+ ?m0 ?m1) 2) 0.5467536) ") + BaCl2 (" (* (/ (+ ?m0 ?m1) 2) 0.5467536) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.5467536) ")")))
)


(defrule ХлоридБария_ДигидрогенаМонооксид_ГидроксидБария_Водород_Хлор
   (declare (salience 40))
   (element (formula ХлоридБария) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.5777413))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.5777413))))
   (assert (element (formula Хлор) (mass (* (/ (+ ?m0 ?m1) 2) 0.5777413))))
   (assert (appendmessagehalt (str-cat "BaCl2 (" ?m0 ") + H2O (" ?m1 ") -(0.5777413)> Ba(OH)2 (" (* (/ (+ ?m0 ?m1) 2) 0.5777413) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.5777413) ") + Cl2 (" (* (/ (+ ?m0 ?m1) 2) 0.5777413) ")")))
)


(defrule ГидроксидБария_Хлор_ХлоридБария_ХлоратБария_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидБария) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ХлоридБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.7475124))))
   (assert (element (formula ХлоратБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.7475124))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.7475124))))
   (assert (appendmessagehalt (str-cat "Ba(OH)2 (" ?m0 ") + Cl2 (" ?m1 ") -(0.7475124)> BaCl2 (" (* (/ (+ ?m0 ?m1) 2) 0.7475124) ") + Ba(ClO3)2 (" (* (/ (+ ?m0 ?m1) 2) 0.7475124) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.7475124) ")")))
)


(defrule ПерхлоратНатрия_ХлоридКалия_ПерхлоратКалия_ХлоридНатрия
   (declare (salience 40))
   (element (formula ПерхлоратНатрия) (mass ?m0))
   (element (formula ХлоридКалия) (mass ?m1))
   =>
   (assert (element (formula ПерхлоратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.5672417))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.5672417))))
   (assert (appendmessagehalt (str-cat "NaClO4 (" ?m0 ") + KCl (" ?m1 ") -(0.5672417)> KClO4 (" (* (/ (+ ?m0 ?m1) 2) 0.5672417) ") + NaCl (" (* (/ (+ ?m0 ?m1) 2) 0.5672417) ")")))
)


(defrule ХлоратКалия_Электролиз_ПерхлоратКалия_ХлоридКалия
   (declare (salience 40))
   (element (formula ХлоратКалия) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   =>
   (assert (element (formula ПерхлоратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.691506))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.691506))))
   (assert (appendmessagehalt (str-cat "KClO3 (" ?m0 ") + e (" ?m1 ") -(0.691506)> KClO4 (" (* (/ (+ ?m0 ?m1) 2) 0.691506) ") + KCl (" (* (/ (+ ?m0 ?m1) 2) 0.691506) ")")))
)


(defrule ХлоратКалия_Тепло_ПерхлоратКалия_ХлоридКалия
   (declare (salience 40))
   (element (formula ХлоратКалия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ПерхлоратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.418193))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.418193))))
   (assert (appendmessagehalt (str-cat "KClO3 (" ?m0 ") + t (" ?m1 ") -(0.418193)> KClO4 (" (* (/ (+ ?m0 ?m1) 2) 0.418193) ") + KCl (" (* (/ (+ ?m0 ?m1) 2) 0.418193) ")")))
)


(defrule ПерманганатКалия_СернаяКислота_ОксидМарганца_СульфатКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ПерманганатКалия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula ОксидМарганца) (mass (* (/ (+ ?m0 ?m1) 2) 0.7408922))))
   (assert (element (formula СульфатКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7408922))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.7408922))))
   (assert (appendmessagehalt (str-cat "KMnO4 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.7408922)> Mn2O7 (" (* (/ (+ ?m0 ?m1) 2) 0.7408922) ") + K2SO4 (" (* (/ (+ ?m0 ?m1) 2) 0.7408922) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.7408922) ")")))
)


(defrule ОксидМарганца_ОксидМарганца_Кислород_Озон_Тепло
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   =>
   (assert (element (formula ОксидМарганца) (mass (* (/ ?m0 1) 0.9201239))))
   (assert (element (formula Кислород) (mass (* (/ ?m0 1) 0.9201239))))
   (assert (element (formula Озон) (mass (* (/ ?m0 1) 0.9201239))))
   (assert (element (formula Тепло) (mass (* (/ ?m0 1) 0.9201239))))
   (assert (appendmessagehalt (str-cat "Mn2O7 (" ?m0 ") -(0.9201239)> MnO2 (" (* (/ ?m0 1) 0.9201239) ") + O2 (" (* (/ ?m0 1) 0.9201239) ") + O3 (" (* (/ ?m0 1) 0.9201239) ") + t (" (* (/ ?m0 1) 0.9201239) ")")))
)


(defrule ОксидМарганца_ДигидрогенаМонооксид_МарганцоваяКислота
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula МарганцоваяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.801498))))
   (assert (appendmessagehalt (str-cat "Mn2O7 (" ?m0 ") + H2O (" ?m1 ") -(0.801498)> HMnO4 (" (* (/ (+ ?m0 ?m1) 2) 0.801498) ")")))
)


(defrule ХлоридНатрия_СернаяКислота_СульфатНатрия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридНатрия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula СульфатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.5972683))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.5972683))))
   (assert (appendmessagehalt (str-cat "NaCl (" ?m0 ") + H2SO4 (" ?m1 ") -(0.5972683)> Na2SO4 (" (* (/ (+ ?m0 ?m1) 2) 0.5972683) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.5972683) ")")))
)


(defrule ОксидКальция_ДигидрогенаМонооксид_ГидроксидКальция
   (declare (salience 40))
   (element (formula ОксидКальция) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.7752278))))
   (assert (appendmessagehalt (str-cat "CaO (" ?m0 ") + H2O (" ?m1 ") -(0.7752278)> Ca(OH)2 (" (* (/ (+ ?m0 ?m1) 2) 0.7752278) ")")))
)


(defrule ГидроксидКальция_УглекислыйГаз_КарбонатКальция_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидКальция) (mass ?m0))
   (element (formula УглекислыйГаз) (mass ?m1))
   =>
   (assert (element (formula КарбонатКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.6187749))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.6187749))))
   (assert (appendmessagehalt (str-cat "Ca(OH)2 (" ?m0 ") + CO2 (" ?m1 ") -(0.6187749)> CaCO3 (" (* (/ (+ ?m0 ?m1) 2) 0.6187749) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.6187749) ")")))
)


(defrule Кремний_ГидроксидНатрия_ОртосиликатНатрия_Водород
   (declare (salience 40))
   (element (formula Кремний) (mass ?m0))
   (element (formula ГидроксидНатрия) (mass ?m1))
   =>
   (assert (element (formula ОртосиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.5063274))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.5063274))))
   (assert (appendmessagehalt (str-cat "Si (" ?m0 ") + NaOH (" ?m1 ") -(0.5063274)> Na4SiO4 (" (* (/ (+ ?m0 ?m1) 2) 0.5063274) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.5063274) ")")))
)


(defrule ОксидКремния_ГидроксидНатрия_ОртосиликатНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидКремния) (mass ?m0))
   (element (formula ГидроксидНатрия) (mass ?m1))
   =>
   (assert (element (formula ОртосиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.8377992))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.8377992))))
   (assert (appendmessagehalt (str-cat "SiO2 (" ?m0 ") + NaOH (" ?m1 ") -(0.8377992)> Na4SiO4 (" (* (/ (+ ?m0 ?m1) 2) 0.8377992) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.8377992) ")")))
)


(defrule ОксидКремния_КарбонатНатрия_ОртосиликатНатрия_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидКремния) (mass ?m0))
   (element (formula КарбонатНатрия) (mass ?m1))
   =>
   (assert (element (formula ОртосиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3512301))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.3512301))))
   (assert (appendmessagehalt (str-cat "SiO2 (" ?m0 ") + Na2CO3 (" ?m1 ") -(0.3512301)> Na4SiO4 (" (* (/ (+ ?m0 ?m1) 2) 0.3512301) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.3512301) ")")))
)


(defrule ОксидФосфора_ОксидФосфора5
   (declare (salience 40))
   (element (formula ОксидФосфора) (mass ?m0))
   =>
   (assert (element (formula ОксидФосфора5) (mass (* (/ ?m0 1) 0.8375892))))
   (assert (appendmessagehalt (str-cat "P4O10 (" ?m0 ") -(0.8375892)> P2O5 (" (* (/ ?m0 1) 0.8375892) ")")))
)


(defrule ОксидФосфора5_ОксидФосфора
   (declare (salience 40))
   (element (formula ОксидФосфора5) (mass ?m0))
   =>
   (assert (element (formula ОксидФосфора) (mass (* (/ ?m0 1) 0.6517051))))
   (assert (appendmessagehalt (str-cat "P2O5 (" ?m0 ") -(0.6517051)> P4O10 (" (* (/ ?m0 1) 0.6517051) ")")))
)


(defrule ОксидФосфора5_ДигидрогенаМонооксид_МетафосфорнаяКислота
   (declare (salience 40))
   (element (formula ОксидФосфора5) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula МетафосфорнаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.6267297))))
   (assert (appendmessagehalt (str-cat "P2O5 (" ?m0 ") + H2O (" ?m1 ") -(0.6267297)> HPO3 (" (* (/ (+ ?m0 ?m1) 2) 0.6267297) ")")))
)


(defrule СолянаяКислота_ГидроксидКалия_ХлоридКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СолянаяКислота) (mass ?m0))
   (element (formula ГидроксидКалия) (mass ?m1))
   =>
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.8120957))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.8120957))))
   (assert (appendmessagehalt (str-cat "HCl (" ?m0 ") + KOH (" ?m1 ") -(0.8120957)> KCl (" (* (/ (+ ?m0 ?m1) 2) 0.8120957) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.8120957) ")")))
)


(defrule ОксидХрома_КарбонатНатрия_Кислород_Тепло_ДихроматНатрия
   (declare (salience 40))
   (element (formula ОксидХрома) (mass ?m0))
   (element (formula КарбонатНатрия) (mass ?m1))
   (element (formula Кислород) (mass ?m2))
   (element (formula Тепло) (mass ?m3))
   =>
   (assert (element (formula ДихроматНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.5076377))))
   (assert (appendmessagehalt (str-cat "Cr2O3 (" ?m0 ") + Na2CO3 (" ?m1 ") + O2 (" ?m2 ") + t (" ?m3 ") -(0.5076377)> Na2Cr2O7 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.5076377) ")")))
)


(defrule Ртуть_Кислород_Тепло_ОксидРтути
   (declare (salience 40))
   (element (formula Ртуть) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидРтути) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.5835125))))
   (assert (appendmessagehalt (str-cat "Hg (" ?m0 ") + O2 (" ?m1 ") + t (" ?m2 ") -(0.5835125)> HgO (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.5835125) ")")))
)


(defrule СульфидРтути_ГидроксидНатрия_ОксидРтути_СульфидНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СульфидРтути) (mass ?m0))
   (element (formula ГидроксидНатрия) (mass ?m1))
   =>
   (assert (element (formula ОксидРтути) (mass (* (/ (+ ?m0 ?m1) 2) 0.5020617))))
   (assert (element (formula СульфидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.5020617))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.5020617))))
   (assert (appendmessagehalt (str-cat "HgS (" ?m0 ") + NaOH (" ?m1 ") -(0.5020617)> HgO (" (* (/ (+ ?m0 ?m1) 2) 0.5020617) ") + Na2S (" (* (/ (+ ?m0 ?m1) 2) 0.5020617) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.5020617) ")")))
)


(defrule СульфидРтути_Кислород_Тепло_Ртуть_ДиоксидСеры
   (declare (salience 40))
   (element (formula СульфидРтути) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Ртуть) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6509624))))
   (assert (element (formula ДиоксидСеры) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6509624))))
   (assert (appendmessagehalt (str-cat "HgS (" ?m0 ") + O2 (" ?m1 ") + t (" ?m2 ") -(0.6509624)> Hg (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6509624) ") + SO2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6509624) ")")))
)


(defrule СульфидРтути_Железо_Тепло_Ртуть_ОксидЖелеза3
   (declare (salience 40))
   (element (formula СульфидРтути) (mass ?m0))
   (element (formula Железо) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Ртуть) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8102099))))
   (assert (element (formula ОксидЖелеза3) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8102099))))
   (assert (appendmessagehalt (str-cat "HgS (" ?m0 ") + Fe (" ?m1 ") + t (" ?m2 ") -(0.8102099)> Hg (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8102099) ") + Fe2O3 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8102099) ")")))
)


(defrule Хлор_ГидроксидКалия_ХлоратКалия_ХлоридКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Хлор) (mass ?m0))
   (element (formula ГидроксидКалия) (mass ?m1))
   =>
   (assert (element (formula ХлоратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.828029))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.828029))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.828029))))
   (assert (appendmessagehalt (str-cat "Cl2 (" ?m0 ") + KOH (" ?m1 ") -(0.828029)> KClO3 (" (* (/ (+ ?m0 ?m1) 2) 0.828029) ") + KCl (" (* (/ (+ ?m0 ?m1) 2) 0.828029) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.828029) ")")))
)


(defrule ХлоратНатрия_ХлорноватаяКислота_ХлоратНатрия_ДигидрогенаМонооксид_УглекислыйГаз
   (declare (salience 40))
   (element (formula ХлоратНатрия) (mass ?m0))
   (element (formula ХлорноватаяКислота) (mass ?m1))
   =>
   (assert (element (formula ХлоратНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.4939678))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.4939678))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.4939678))))
   (assert (appendmessagehalt (str-cat "Na2ClO3 (" ?m0 ") + HClO3 (" ?m1 ") -(0.4939678)> NaClO3 (" (* (/ (+ ?m0 ?m1) 2) 0.4939678) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.4939678) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.4939678) ")")))
)


(defrule ГидроксидНатрия_Хлор_ХлоратНатрия_ХлоридНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидНатрия) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ХлоратНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.8249315))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.8249315))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.8249315))))
   (assert (appendmessagehalt (str-cat "NaOH (" ?m0 ") + Cl2 (" ?m1 ") -(0.8249315)> NaClO3 (" (* (/ (+ ?m0 ?m1) 2) 0.8249315) ") + NaCl (" (* (/ (+ ?m0 ?m1) 2) 0.8249315) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.8249315) ")")))
)


(defrule ХлоридНатрия_ДигидрогенаМонооксид_Электролиз_ХлоратНатрия_ХлоридНатрия_Водород
   (declare (salience 40))
   (element (formula ХлоридНатрия) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   (element (formula Электролиз) (mass ?m2))
   =>
   (assert (element (formula ХлоратНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6205679))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6205679))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6205679))))
   (assert (appendmessagehalt (str-cat "NaCl (" ?m0 ") + H2O (" ?m1 ") + e (" ?m2 ") -(0.6205679)> NaClO3 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6205679) ") + NaCl (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6205679) ") + H2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6205679) ")")))
)


(defrule Барий_ДигидрогенаМонооксид_ГидроксидБария_Водород
   (declare (salience 40))
   (element (formula Барий) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.7244954))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.7244954))))
   (assert (appendmessagehalt (str-cat "Ba (" ?m0 ") + H2O (" ?m1 ") -(0.7244954)> Ba(OH)2 (" (* (/ (+ ?m0 ?m1) 2) 0.7244954) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.7244954) ")")))
)


(defrule ОксидБария_ДигидрогенаМонооксид_ГидроксидБария
   (declare (salience 40))
   (element (formula ОксидБария) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.7377759))))
   (assert (appendmessagehalt (str-cat "BaO (" ?m0 ") + H2O (" ?m1 ") -(0.7377759)> Ba(OH)2 (" (* (/ (+ ?m0 ?m1) 2) 0.7377759) ")")))
)


(defrule СульфидБария_ДигидрогенаМонооксид_ГидроксидБария_Сероводород
   (declare (salience 40))
   (element (formula СульфидБария) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.3735293))))
   (assert (element (formula Сероводород) (mass (* (/ (+ ?m0 ?m1) 2) 0.3735293))))
   (assert (appendmessagehalt (str-cat "BaS (" ?m0 ") + H2O (" ?m1 ") -(0.3735293)> Ba(OH)2 (" (* (/ (+ ?m0 ?m1) 2) 0.3735293) ") + H2S (" (* (/ (+ ?m0 ?m1) 2) 0.3735293) ")")))
)


(defrule ХлоратНатрия_Тепло_ПерхлоратНатрия_ХлоридНатрия
   (declare (salience 40))
   (element (formula ХлоратНатрия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ПерхлоратНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.638656))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.638656))))
   (assert (appendmessagehalt (str-cat "NaClO3 (" ?m0 ") + t (" ?m1 ") -(0.638656)> NaClO4 (" (* (/ (+ ?m0 ?m1) 2) 0.638656) ") + NaCl (" (* (/ (+ ?m0 ?m1) 2) 0.638656) ")")))
)


(defrule ОксидМарганца_Хлор_ГидроксидКалия_ПерманганатКалия_ХлоридКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   (element (formula ГидроксидКалия) (mass ?m2))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8100852))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8100852))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8100852))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + Cl2 (" ?m1 ") + KOH (" ?m2 ") -(0.8100852)> KMnO4 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8100852) ") + KCl (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8100852) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8100852) ")")))
)


(defrule ПерманганатКалия_Хлор_ПерманганатКалия_ХлоридКалия
   (declare (salience 40))
   (element (formula ПерманганатКалия) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3369413))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3369413))))
   (assert (appendmessagehalt (str-cat "K2MnO4 (" ?m0 ") + Cl2 (" ?m1 ") -(0.3369413)> KMnO4 (" (* (/ (+ ?m0 ?m1) 2) 0.3369413) ") + KCl (" (* (/ (+ ?m0 ?m1) 2) 0.3369413) ")")))
)


(defrule ПерманганатКалия_ДигидрогенаМонооксид_ПерманганатКалия_ОксидМарганца_ГидроксидКалия_Водород
   (declare (salience 40))
   (element (formula ПерманганатКалия) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7634116))))
   (assert (element (formula ОксидМарганца) (mass (* (/ (+ ?m0 ?m1) 2) 0.7634116))))
   (assert (element (formula ГидроксидКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7634116))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.7634116))))
   (assert (appendmessagehalt (str-cat "K2MnO4 (" ?m0 ") + H2O (" ?m1 ") -(0.7634116)> KMnO4 (" (* (/ (+ ?m0 ?m1) 2) 0.7634116) ") + MnO2 (" (* (/ (+ ?m0 ?m1) 2) 0.7634116) ") + KOH (" (* (/ (+ ?m0 ?m1) 2) 0.7634116) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.7634116) ")")))
)


(defrule КарбонатКальция_Тепло_ОксидКальция_УглекислыйГаз
   (declare (salience 40))
   (element (formula КарбонатКальция) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.7282379))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.7282379))))
   (assert (appendmessagehalt (str-cat "CaCO3 (" ?m0 ") + t (" ?m1 ") -(0.7282379)> CaO (" (* (/ (+ ?m0 ?m1) 2) 0.7282379) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.7282379) ")")))
)


(defrule Кальций_Кислород_ОксидКальция
   (declare (salience 40))
   (element (formula Кальций) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.3707412))))
   (assert (appendmessagehalt (str-cat "Ca (" ?m0 ") + O2 (" ?m1 ") -(0.3707412)> CaO (" (* (/ (+ ?m0 ?m1) 2) 0.3707412) ")")))
)


(defrule НитратКальция_Тепло_ОксидКальция_ОксидАзота4_Кислород
   (declare (salience 40))
   (element (formula НитратКальция) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.5780776))))
   (assert (element (formula ОксидАзота4) (mass (* (/ (+ ?m0 ?m1) 2) 0.5780776))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 2) 0.5780776))))
   (assert (appendmessagehalt (str-cat "Ca(NO3)2 (" ?m0 ") + t (" ?m1 ") -(0.5780776)> CaO (" (* (/ (+ ?m0 ?m1) 2) 0.5780776) ") + NO2 (" (* (/ (+ ?m0 ?m1) 2) 0.5780776) ") + O2 (" (* (/ (+ ?m0 ?m1) 2) 0.5780776) ")")))
)


(defrule ОксидКремния_Марганец_Тепло_ОксидМарганца_Кремний
   (declare (salience 40))
   (element (formula ОксидКремния) (mass ?m0))
   (element (formula Марганец) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидМарганца) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.5395153))))
   (assert (element (formula Кремний) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.5395153))))
   (assert (appendmessagehalt (str-cat "SiO2 (" ?m0 ") + Mn (" ?m1 ") + t (" ?m2 ") -(0.5395153)> MnO (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.5395153) ") + Si (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.5395153) ")")))
)


(defrule ХлоридРтути_Сероводород_Кордероит_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридРтути) (mass ?m0))
   (element (formula Сероводород) (mass ?m1))
   =>
   (assert (element (formula Кордероит) (mass (* (/ (+ ?m0 ?m1) 2) 0.947544))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.947544))))
   (assert (appendmessagehalt (str-cat "HgCl2 (" ?m0 ") + H2S (" ?m1 ") -(0.947544)> Hg3S2Cl2 (" (* (/ (+ ?m0 ?m1) 2) 0.947544) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.947544) ")")))
)


(defrule Кордероит_Сероводород_СульфидРтути_СолянаяКислота
   (declare (salience 40))
   (element (formula Кордероит) (mass ?m0))
   (element (formula Сероводород) (mass ?m1))
   =>
   (assert (element (formula СульфидРтути) (mass (* (/ (+ ?m0 ?m1) 2) 0.5682931))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.5682931))))
   (assert (appendmessagehalt (str-cat "Hg3S2Cl2 (" ?m0 ") + H2S (" ?m1 ") -(0.5682931)> HgS (" (* (/ (+ ?m0 ?m1) 2) 0.5682931) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.5682931) ")")))
)


(defrule СульфатБария_Углерод_СульфидБария_УгарныйГаз
   (declare (salience 40))
   (element (formula СульфатБария) (mass ?m0))
   (element (formula Углерод) (mass ?m1))
   =>
   (assert (element (formula СульфидБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.8913814))))
   (assert (element (formula УгарныйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.8913814))))
   (assert (appendmessagehalt (str-cat "BaSO4 (" ?m0 ") + C (" ?m1 ") -(0.8913814)> BaS (" (* (/ (+ ?m0 ?m1) 2) 0.8913814) ") + CO (" (* (/ (+ ?m0 ?m1) 2) 0.8913814) ")")))
)


(defrule ГидроксидБария_Сероводород_СульфидБария_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидБария) (mass ?m0))
   (element (formula Сероводород) (mass ?m1))
   =>
   (assert (element (formula СульфидБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.5738385))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.5738385))))
   (assert (appendmessagehalt (str-cat "Ba(OH)2 (" ?m0 ") + H2S (" ?m1 ") -(0.5738385)> BaS (" (* (/ (+ ?m0 ?m1) 2) 0.5738385) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.5738385) ")")))
)


(defrule ОксидМарганца_ГидроксидКалия_НитратКалия_Тепло_ПерманганатКалия_НитритКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula ГидроксидКалия) (mass ?m1))
   (element (formula НитратКалия) (mass ?m2))
   (element (formula Тепло) (mass ?m3))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6891788))))
   (assert (element (formula НитритКалия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6891788))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6891788))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + KOH (" ?m1 ") + KNO3 (" ?m2 ") + t (" ?m3 ") -(0.6891788)> K2MnO4 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6891788) ") + KNO2 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6891788) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6891788) ")")))
)


(defrule ОксидМарганца_КарбонатКалия_ХлоратКалия_Тепло_ПерманганатКалия_ХлоридКалия_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula КарбонатКалия) (mass ?m1))
   (element (formula ХлоратКалия) (mass ?m2))
   (element (formula Тепло) (mass ?m3))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6721109))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6721109))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6721109))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + K2CO3 (" ?m1 ") + KClO3 (" ?m2 ") + t (" ?m3 ") -(0.6721109)> K2MnO4 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6721109) ") + KCl (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6721109) ") + CO2 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6721109) ")")))
)


(defrule ОксидМарганца_ГидроксидКалия_Кислород_Тепло_ПерманганатКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula ГидроксидКалия) (mass ?m1))
   (element (formula Кислород) (mass ?m2))
   (element (formula Тепло) (mass ?m3))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6912684))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6912684))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + KOH (" ?m1 ") + O2 (" ?m2 ") + t (" ?m3 ") -(0.6912684)> K2MnO4 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6912684) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.6912684) ")")))
)


(defrule ПерманганатКалия_Тепло_ПерманганатКалия_ОксидМарганца_Кислород
   (declare (salience 40))
   (element (formula ПерманганатКалия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.8611234))))
   (assert (element (formula ОксидМарганца) (mass (* (/ (+ ?m0 ?m1) 2) 0.8611234))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 2) 0.8611234))))
   (assert (appendmessagehalt (str-cat "KMnO4 (" ?m0 ") + t (" ?m1 ") -(0.8611234)> K2MnO4 (" (* (/ (+ ?m0 ?m1) 2) 0.8611234) ") + MnO2 (" (* (/ (+ ?m0 ?m1) 2) 0.8611234) ") + O2 (" (* (/ (+ ?m0 ?m1) 2) 0.8611234) ")")))
)


(defrule ОксидМарганца_ПероксидКалия_Тепло_ПерманганатКалия
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula ПероксидКалия) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.5902963))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + K2O2 (" ?m1 ") + t (" ?m2 ") -(0.5902963)> K2MnO4 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.5902963) ")")))
)


(defrule КарбонатКальция_АзотнаяКислота_НитратКальция_УглекислыйГаз_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula КарбонатКальция) (mass ?m0))
   (element (formula АзотнаяКислота) (mass ?m1))
   =>
   (assert (element (formula НитратКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.5766997))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.5766997))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.5766997))))
   (assert (appendmessagehalt (str-cat "CaCO3 (" ?m0 ") + HNO3 (" ?m1 ") -(0.5766997)> Ca(NO3)2 (" (* (/ (+ ?m0 ?m1) 2) 0.5766997) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.5766997) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.5766997) ")")))
)


(defrule НитратКальция_Тепло_ОксидКальция_ОксидАзота4_Кислород
   (declare (salience 40))
   (element (formula НитратКальция) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.7656608))))
   (assert (element (formula ОксидАзота4) (mass (* (/ (+ ?m0 ?m1) 2) 0.7656608))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 2) 0.7656608))))
   (assert (appendmessagehalt (str-cat "Ca(NO3)2 (" ?m0 ") + t (" ?m1 ") -(0.7656608)> CaO (" (* (/ (+ ?m0 ?m1) 2) 0.7656608) ") + NO2 (" (* (/ (+ ?m0 ?m1) 2) 0.7656608) ") + O2 (" (* (/ (+ ?m0 ?m1) 2) 0.7656608) ")")))
)


(defrule Кальций_АзотнаяКислота_НитратКальция_ОксидАзота1_ОксидАзота2_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Кальций) (mass ?m0))
   (element (formula АзотнаяКислота) (mass ?m1))
   =>
   (assert (element (formula НитратКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.4824747))))
   (assert (element (formula ОксидАзота1) (mass (* (/ (+ ?m0 ?m1) 2) 0.4824747))))
   (assert (element (formula ОксидАзота2) (mass (* (/ (+ ?m0 ?m1) 2) 0.4824747))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.4824747))))
   (assert (appendmessagehalt (str-cat "Ca (" ?m0 ") + HNO3 (" ?m1 ") -(0.4824747)> Ca(NO3)2 (" (* (/ (+ ?m0 ?m1) 2) 0.4824747) ") + N2O (" (* (/ (+ ?m0 ?m1) 2) 0.4824747) ") + NO (" (* (/ (+ ?m0 ?m1) 2) 0.4824747) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.4824747) ")")))
)


(defrule ОксидКальция_АзотнаяКислота_НитратКальция_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидКальция) (mass ?m0))
   (element (formula АзотнаяКислота) (mass ?m1))
   =>
   (assert (element (formula НитратКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.4110257))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.4110257))))
   (assert (appendmessagehalt (str-cat "CaO (" ?m0 ") + HNO3 (" ?m1 ") -(0.4110257)> Ca(NO3)2 (" (* (/ (+ ?m0 ?m1) 2) 0.4110257) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.4110257) ")")))
)


(defrule ГидроксидКальция_ОксидАзота4_НитратКальция_НитритКальция_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидКальция) (mass ?m0))
   (element (formula ОксидАзота4) (mass ?m1))
   =>
   (assert (element (formula НитратКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.3144476))))
   (assert (element (formula НитритКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.3144476))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.3144476))))
   (assert (appendmessagehalt (str-cat "Ca(OH)2 (" ?m0 ") + NO2 (" ?m1 ") -(0.3144476)> Ca(NO3)2 (" (* (/ (+ ?m0 ?m1) 2) 0.3144476) ") + Ca(NO2)2 (" (* (/ (+ ?m0 ?m1) 2) 0.3144476) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.3144476) ")")))
)


(defrule СульфидКальция_АзотнаяКислота_НитратКальция_Сера_ОксидАзота4_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СульфидКальция) (mass ?m0))
   (element (formula АзотнаяКислота) (mass ?m1))
   =>
   (assert (element (formula НитратКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.8872942))))
   (assert (element (formula Сера) (mass (* (/ (+ ?m0 ?m1) 2) 0.8872942))))
   (assert (element (formula ОксидАзота4) (mass (* (/ (+ ?m0 ?m1) 2) 0.8872942))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.8872942))))
   (assert (appendmessagehalt (str-cat "CaS (" ?m0 ") + HNO3 (" ?m1 ") -(0.8872942)> Ca(NO3)2 (" (* (/ (+ ?m0 ?m1) 2) 0.8872942) ") + S (" (* (/ (+ ?m0 ?m1) 2) 0.8872942) ") + NO2 (" (* (/ (+ ?m0 ?m1) 2) 0.8872942) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.8872942) ")")))
)


(defrule ОксидМарганца_Тепло_ОксидМарганца
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидМарганца) (mass (* (/ (+ ?m0 ?m1) 2) 0.3945018))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + t (" ?m1 ") -(0.3945018)> Mn2O3 (" (* (/ (+ ?m0 ?m1) 2) 0.3945018) ")")))
)


(defrule ОксидМарганца_Алюминий_Тепло_Марганец_ОксидАлюминия_Тепло
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula Алюминий) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Марганец) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3446919))))
   (assert (element (formula ОксидАлюминия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3446919))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3446919))))
   (assert (appendmessagehalt (str-cat "Mn2O3 (" ?m0 ") + Al (" ?m1 ") + t (" ?m2 ") -(0.3446919)> Mn (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3446919) ") + Al2O3 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3446919) ") + t (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3446919) ")")))
)


(defrule СульфидРтути_ХлоридРтути_Тепло_Кордероит
   (declare (salience 40))
   (element (formula СульфидРтути) (mass ?m0))
   (element (formula ХлоридРтути) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Кордероит) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8767788))))
   (assert (appendmessagehalt (str-cat "HgS (" ?m0 ") + HgCl2 (" ?m1 ") + t (" ?m2 ") -(0.8767788)> Hg3S2Cl2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8767788) ")")))
)


(defrule СульфидЖелеза_СолянаяКислота_Сероводород_ХлоридЖелеза
   (declare (salience 40))
   (element (formula СульфидЖелеза) (mass ?m0))
   (element (formula СолянаяКислота) (mass ?m1))
   =>
   (assert (element (formula Сероводород) (mass (* (/ (+ ?m0 ?m1) 2) 0.8873025))))
   (assert (element (formula ХлоридЖелеза) (mass (* (/ (+ ?m0 ?m1) 2) 0.8873025))))
   (assert (appendmessagehalt (str-cat "FeS (" ?m0 ") + HCl (" ?m1 ") -(0.8873025)> H2S (" (* (/ (+ ?m0 ?m1) 2) 0.8873025) ") + FeCl2 (" (* (/ (+ ?m0 ?m1) 2) 0.8873025) ")")))
)


(defrule СульфидАлюминия_ДигидрогенаМонооксид_Сероводород_ГидроксидАлюминия
   (declare (salience 40))
   (element (formula СульфидАлюминия) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula Сероводород) (mass (* (/ (+ ?m0 ?m1) 2) 0.6892128))))
   (assert (element (formula ГидроксидАлюминия) (mass (* (/ (+ ?m0 ?m1) 2) 0.6892128))))
   (assert (appendmessagehalt (str-cat "Al2S3 (" ?m0 ") + H2O (" ?m1 ") -(0.6892128)> H2S (" (* (/ (+ ?m0 ?m1) 2) 0.6892128) ") + Al(OH)3 (" (* (/ (+ ?m0 ?m1) 2) 0.6892128) ")")))
)


(defrule НитратКальция_КарбонатКалия_НитратКалия_КарбонатКальция
   (declare (salience 40))
   (element (formula НитратКальция) (mass ?m0))
   (element (formula КарбонатКалия) (mass ?m1))
   =>
   (assert (element (formula НитратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.4975382))))
   (assert (element (formula КарбонатКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.4975382))))
   (assert (appendmessagehalt (str-cat "Ca(NO3)2 (" ?m0 ") + K2CO3 (" ?m1 ") -(0.4975382)> KNO3 (" (* (/ (+ ?m0 ?m1) 2) 0.4975382) ") + CaCO3 (" (* (/ (+ ?m0 ?m1) 2) 0.4975382) ")")))
)


(defrule НитратКальция_СульфатКалия_НитратКалия_СульфатКальция
   (declare (salience 40))
   (element (formula НитратКальция) (mass ?m0))
   (element (formula СульфатКалия) (mass ?m1))
   =>
   (assert (element (formula НитратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.5432615))))
   (assert (element (formula СульфатКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.5432615))))
   (assert (appendmessagehalt (str-cat "Ca(NO3)2 (" ?m0 ") + K2SO4 (" ?m1 ") -(0.5432615)> KNO3 (" (* (/ (+ ?m0 ?m1) 2) 0.5432615) ") + CaSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.5432615) ")")))
)


(defrule Калий_Кислород_Холод_ПероксидКалия
   (declare (salience 40))
   (element (formula Калий) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Холод) (mass ?m2))
   =>
   (assert (element (formula ПероксидКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4203243))))
   (assert (appendmessagehalt (str-cat "K (" ?m0 ") + O2 (" ?m1 ") + not_t (" ?m2 ") -(0.4203243)> K2O2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4203243) ")")))
)


(defrule ОксидКальция_Тепло_ПероксидКалия_Кислород
   (declare (salience 40))
   (element (formula ОксидКальция) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ПероксидКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.4956285))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 2) 0.4956285))))
   (assert (appendmessagehalt (str-cat "KO2 (" ?m0 ") + t (" ?m1 ") -(0.4956285)> K2O2 (" (* (/ (+ ?m0 ?m1) 2) 0.4956285) ") + O2 (" (* (/ (+ ?m0 ?m1) 2) 0.4956285) ")")))
)


(defrule ОксидАлюминия_Электролиз_Тепло_Криолит_Алюминий_Кислород_Криолит
   (declare (salience 40))
   (element (formula ОксидАлюминия) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   (element (formula Криолит) (mass ?m3))
   =>
   (assert (element (formula Алюминий) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.3637221))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.3637221))))
   (assert (element (formula Криолит) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.3637221))))
   (assert (appendmessagehalt (str-cat "Al2O3 (" ?m0 ") + e (" ?m1 ") + t (" ?m2 ") + Na3AlF6 (" ?m3 ") -(0.3637221)> Al (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.3637221) ") + O2 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.3637221) ") + Na3AlF6 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 4) 0.3637221) ")")))
)


(defrule ХлоридАлюминия_Калий_Тепло_ХлоридКалия_Алюминий
   (declare (salience 40))
   (element (formula ХлоридАлюминия) (mass ?m0))
   (element (formula Калий) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.523739))))
   (assert (element (formula Алюминий) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.523739))))
   (assert (appendmessagehalt (str-cat "AlCl3 (" ?m0 ") + K (" ?m1 ") + t (" ?m2 ") -(0.523739)> KCl (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.523739) ") + Al (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.523739) ")")))
)


(defrule Железо_Сера_СульфидЖелеза
   (declare (salience 40))
   (element (formula Железо) (mass ?m0))
   (element (formula Сера) (mass ?m1))
   =>
   (assert (element (formula СульфидЖелеза) (mass (* (/ (+ ?m0 ?m1) 2) 0.4365719))))
   (assert (appendmessagehalt (str-cat "Fe (" ?m0 ") + S (" ?m1 ") -(0.4365719)> FeS (" (* (/ (+ ?m0 ?m1) 2) 0.4365719) ")")))
)


(defrule СульфидЖелеза_Тепло_СульфидЖелеза
   (declare (salience 40))
   (element (formula СульфидЖелеза) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula СульфидЖелеза) (mass (* (/ (+ ?m0 ?m1) 2) 0.7586896))))
   (assert (appendmessagehalt (str-cat "FeS2 (" ?m0 ") + t (" ?m1 ") -(0.7586896)> FeS (" (* (/ (+ ?m0 ?m1) 2) 0.7586896) ")")))
)


(defrule ОксидЖелеза3_Водород_Сероводород_СульфидЖелеза_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидЖелеза3) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   (element (formula Сероводород) (mass ?m2))
   =>
   (assert (element (formula СульфидЖелеза) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4693861))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4693861))))
   (assert (appendmessagehalt (str-cat "Fe2O3 (" ?m0 ") + H2 (" ?m1 ") + H2S (" ?m2 ") -(0.4693861)> FeS (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4693861) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4693861) ")")))
)


(defrule Алюминий_Сера_Тепло_СульфидАлюминия
   (declare (salience 40))
   (element (formula Алюминий) (mass ?m0))
   (element (formula Сера) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula СульфидАлюминия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3743876))))
   (assert (appendmessagehalt (str-cat "Al (" ?m0 ") + S (" ?m1 ") + t (" ?m2 ") -(0.3743876)> Al2S3 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3743876) ")")))
)


(defrule Натрий_ГидроксидКалия_ГидроксидНатрия_Калий
   (declare (salience 40))
   (element (formula Натрий) (mass ?m0))
   (element (formula ГидроксидКалия) (mass ?m1))
   =>
   (assert (element (formula ГидроксидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.5729923))))
   (assert (element (formula Калий) (mass (* (/ (+ ?m0 ?m1) 2) 0.5729923))))
   (assert (appendmessagehalt (str-cat "Na (" ?m0 ") + KOH (" ?m1 ") -(0.5729923)> NaOH (" (* (/ (+ ?m0 ?m1) 2) 0.5729923) ") + K (" (* (/ (+ ?m0 ?m1) 2) 0.5729923) ")")))
)


(defrule ОксидМеди_Алюминий_Тепло_ОксидАлюминия_Медь
   (declare (salience 40))
   (element (formula ОксидМеди) (mass ?m0))
   (element (formula Алюминий) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидАлюминия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.766848))))
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.766848))))
   (assert (appendmessagehalt (str-cat "Cu2O (" ?m0 ") + Al (" ?m1 ") + t (" ?m2 ") -(0.766848)> Al2O3 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.766848) ") + Cu (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.766848) ")")))
)


(defrule ГидроксидАлюминия_Тепло_ОксидАлюминия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидАлюминия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидАлюминия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3736275))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.3736275))))
   (assert (appendmessagehalt (str-cat "Al(OH)3 (" ?m0 ") + t (" ?m1 ") -(0.3736275)> Al2O3 (" (* (/ (+ ?m0 ?m1) 2) 0.3736275) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.3736275) ")")))
)


(defrule ОксидЖелеза3_Водород_Тепло_Железо_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидЖелеза3) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Железо) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3872144))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3872144))))
   (assert (appendmessagehalt (str-cat "Fe2O3 (" ?m0 ") + H2 (" ?m1 ") + t (" ?m2 ") -(0.3872144)> Fe (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3872144) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3872144) ")")))
)


(defrule ОксидЖелеза3_УгарныйГаз_Железо_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидЖелеза3) (mass ?m0))
   (element (formula УгарныйГаз) (mass ?m1))
   =>
   (assert (element (formula Железо) (mass (* (/ (+ ?m0 ?m1) 2) 0.8145517))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.8145517))))
   (assert (appendmessagehalt (str-cat "Fe2O3 (" ?m0 ") + CO (" ?m1 ") -(0.8145517)> Fe (" (* (/ (+ ?m0 ?m1) 2) 0.8145517) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.8145517) ")")))
)


(defrule ОксидЖелеза_УгарныйГаз_Железо_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидЖелеза) (mass ?m0))
   (element (formula УгарныйГаз) (mass ?m1))
   =>
   (assert (element (formula Железо) (mass (* (/ (+ ?m0 ?m1) 2) 0.8893445))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.8893445))))
   (assert (appendmessagehalt (str-cat "FeO (" ?m0 ") + CO (" ?m1 ") -(0.8893445)> Fe (" (* (/ (+ ?m0 ?m1) 2) 0.8893445) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.8893445) ")")))
)


(defrule ОксидЖелеза_УгарныйГаз_Железо_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидЖелеза) (mass ?m0))
   (element (formula УгарныйГаз) (mass ?m1))
   =>
   (assert (element (formula Железо) (mass (* (/ (+ ?m0 ?m1) 2) 0.6421311))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.6421311))))
   (assert (appendmessagehalt (str-cat "FeO (" ?m0 ") + CO (" ?m1 ") -(0.6421311)> Fe (" (* (/ (+ ?m0 ?m1) 2) 0.6421311) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.6421311) ")")))
)


(defrule ОксидЖелеза3_Алюминий_Железо_ОксидАлюминия
   (declare (salience 40))
   (element (formula ОксидЖелеза3) (mass ?m0))
   (element (formula Алюминий) (mass ?m1))
   =>
   (assert (element (formula Железо) (mass (* (/ (+ ?m0 ?m1) 2) 0.8782233))))
   (assert (element (formula ОксидАлюминия) (mass (* (/ (+ ?m0 ?m1) 2) 0.8782233))))
   (assert (appendmessagehalt (str-cat "Fe2O3 (" ?m0 ") + Al (" ?m1 ") -(0.8782233)> Fe (" (* (/ (+ ?m0 ?m1) 2) 0.8782233) ") + Al2O3 (" (* (/ (+ ?m0 ?m1) 2) 0.8782233) ")")))
)


(defrule Медь_Кислород_Тепло_ОксидМеди2_ОксидМеди
   (declare (salience 40))
   (element (formula Медь) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидМеди2) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.9117836))))
   (assert (element (formula ОксидМеди) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.9117836))))
   (assert (appendmessagehalt (str-cat "Cu (" ?m0 ") + O2 (" ?m1 ") + t (" ?m2 ") -(0.9117836)> CuO (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.9117836) ") + Cu2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.9117836) ")")))
)


(defrule Медь_ОксидАзота1_Тепло_ОксидМеди_Азот
   (declare (salience 40))
   (element (formula Медь) (mass ?m0))
   (element (formula ОксидАзота1) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидМеди) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4380991))))
   (assert (element (formula Азот) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4380991))))
   (assert (appendmessagehalt (str-cat "Cu (" ?m0 ") + N2O (" ?m1 ") + t (" ?m2 ") -(0.4380991)> Cu2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4380991) ") + N2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4380991) ")")))
)


(defrule ОксидМеди2_Углерод_Медь_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидМеди2) (mass ?m0))
   (element (formula Углерод) (mass ?m1))
   =>
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1) 2) 0.4367606))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.4367606))))
   (assert (appendmessagehalt (str-cat "CuO (" ?m0 ") + C (" ?m1 ") -(0.4367606)> Cu (" (* (/ (+ ?m0 ?m1) 2) 0.4367606) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.4367606) ")")))
)


(defrule ОксидМеди2_Водород_Медь_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМеди2) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   =>
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1) 2) 0.5828444))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.5828444))))
   (assert (appendmessagehalt (str-cat "CuO (" ?m0 ") + H2 (" ?m1 ") -(0.5828444)> Cu (" (* (/ (+ ?m0 ?m1) 2) 0.5828444) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.5828444) ")")))
)


(defrule Малахит_Тепло_ОксидМеди2_УглекислыйГаз_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Малахит) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидМеди2) (mass (* (/ (+ ?m0 ?m1) 2) 0.5346353))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.5346353))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.5346353))))
   (assert (appendmessagehalt (str-cat "(CuOH)2CO3 (" ?m0 ") + t (" ?m1 ") -(0.5346353)> CuO (" (* (/ (+ ?m0 ?m1) 2) 0.5346353) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.5346353) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.5346353) ")")))
)


(defrule Малахит_УгарныйГаз_Тепло_УглекислыйГаз_Медь_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Малахит) (mass ?m0))
   (element (formula УгарныйГаз) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3438683))))
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3438683))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3438683))))
   (assert (appendmessagehalt (str-cat "(CuOH)2CO3 (" ?m0 ") + CO (" ?m1 ") + t (" ?m2 ") -(0.3438683)> CO2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3438683) ") + Cu (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3438683) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.3438683) ")")))
)


(defrule ХлоридБария_Электролиз_Барий_Хлор
   (declare (salience 40))
   (element (formula ХлоридБария) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   =>
   (assert (element (formula Барий) (mass (* (/ (+ ?m0 ?m1) 2) 0.9088347))))
   (assert (element (formula Хлор) (mass (* (/ (+ ?m0 ?m1) 2) 0.9088347))))
   (assert (appendmessagehalt (str-cat "BaCl2 (" ?m0 ") + e (" ?m1 ") -(0.9088347)> Ba (" (* (/ (+ ?m0 ?m1) 2) 0.9088347) ") + Cl2 (" (* (/ (+ ?m0 ?m1) 2) 0.9088347) ")")))
)


(defrule СолянаяКислота_ОксидМарганца_Хлор_ХлоридМарганца_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СолянаяКислота) (mass ?m0))
   (element (formula ОксидМарганца) (mass ?m1))
   =>
   (assert (element (formula Хлор) (mass (* (/ (+ ?m0 ?m1) 2) 0.5553011))))
   (assert (element (formula ХлоридМарганца) (mass (* (/ (+ ?m0 ?m1) 2) 0.5553011))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.5553011))))
   (assert (appendmessagehalt (str-cat "HCl (" ?m0 ") + MnO2 (" ?m1 ") -(0.5553011)> Cl2 (" (* (/ (+ ?m0 ?m1) 2) 0.5553011) ") + MnCl2 (" (* (/ (+ ?m0 ?m1) 2) 0.5553011) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.5553011) ")")))
)


(defrule ХлоридНатрия_Электролиз_Натрий_Хлор
   (declare (salience 40))
   (element (formula ХлоридНатрия) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   =>
   (assert (element (formula Натрий) (mass (* (/ (+ ?m0 ?m1) 2) 0.9125035))))
   (assert (element (formula Хлор) (mass (* (/ (+ ?m0 ?m1) 2) 0.9125035))))
   (assert (appendmessagehalt (str-cat "NaCl (" ?m0 ") + e (" ?m1 ") -(0.9125035)> Na (" (* (/ (+ ?m0 ?m1) 2) 0.9125035) ") + Cl2 (" (* (/ (+ ?m0 ?m1) 2) 0.9125035) ")")))
)


(defrule ХлоридКалия_ДигидрогенаМонооксид_Электролиз_ГидроксидКалия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридКалия) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   (element (formula Электролиз) (mass ?m2))
   =>
   (assert (element (formula ГидроксидКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6242085))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6242085))))
   (assert (appendmessagehalt (str-cat "KCl (" ?m0 ") + H2O (" ?m1 ") + e (" ?m2 ") -(0.6242085)> KOH (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6242085) ") + HCl (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6242085) ")")))
)


(defrule Халькопирит_Кислород_Тепло_СульфидМеди_ОксидЖелеза
   (declare (salience 40))
   (element (formula Халькопирит) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula СульфидМеди) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8727911))))
   (assert (element (formula ОксидЖелеза) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8727911))))
   (assert (appendmessagehalt (str-cat "CuFeS2 (" ?m0 ") + O2 (" ?m1 ") + t (" ?m2 ") -(0.8727911)> Cu2S (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8727911) ") + FeO (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8727911) ")")))
)


(defrule СульфидМеди_ДигидрогенаМонооксид_Тепло_Медь_ДиоксидСеры_Водород
   (declare (salience 40))
   (element (formula СульфидМеди) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8924395))))
   (assert (element (formula ДиоксидСеры) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8924395))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8924395))))
   (assert (appendmessagehalt (str-cat "Cu2S (" ?m0 ") + H2O (" ?m1 ") + t (" ?m2 ") -(0.8924395)> Cu (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8924395) ") + SO2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8924395) ") + H2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8924395) ")")))
)


(defrule СульфидМеди_Тепло_Медь_Сера
   (declare (salience 40))
   (element (formula СульфидМеди) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1) 2) 0.7187197))))
   (assert (element (formula Сера) (mass (* (/ (+ ?m0 ?m1) 2) 0.7187197))))
   (assert (appendmessagehalt (str-cat "Cu2S (" ?m0 ") + t (" ?m1 ") -(0.7187197)> Cu (" (* (/ (+ ?m0 ?m1) 2) 0.7187197) ") + S (" (* (/ (+ ?m0 ?m1) 2) 0.7187197) ")")))
)


(defrule СульфидСвинца_СолянаяКислота_ХлоридСвинца_Сероводород
   (declare (salience 40))
   (element (formula СульфидСвинца) (mass ?m0))
   (element (formula СолянаяКислота) (mass ?m1))
   =>
   (assert (element (formula ХлоридСвинца) (mass (* (/ (+ ?m0 ?m1) 2) 0.801459))))
   (assert (element (formula Сероводород) (mass (* (/ (+ ?m0 ?m1) 2) 0.801459))))
   (assert (appendmessagehalt (str-cat "PbS (" ?m0 ") + HCl (" ?m1 ") -(0.801459)> PbCl2 (" (* (/ (+ ?m0 ?m1) 2) 0.801459) ") + H2S (" (* (/ (+ ?m0 ?m1) 2) 0.801459) ")")))
)


(defrule СульфидСвинца_Водород_Тепло_Свинец_Сероводород
   (declare (salience 40))
   (element (formula СульфидСвинца) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Свинец) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4334388))))
   (assert (element (formula Сероводород) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4334388))))
   (assert (appendmessagehalt (str-cat "PbS (" ?m0 ") + H2 (" ?m1 ") + t (" ?m2 ") -(0.4334388)> Pb (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4334388) ") + H2S (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4334388) ")")))
)


(defrule СульфидСвинца_Озон_СульфатСвинца_Кислород
   (declare (salience 40))
   (element (formula СульфидСвинца) (mass ?m0))
   (element (formula Озон) (mass ?m1))
   =>
   (assert (element (formula СульфатСвинца) (mass (* (/ (+ ?m0 ?m1) 2) 0.8388648))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 2) 0.8388648))))
   (assert (appendmessagehalt (str-cat "PbS (" ?m0 ") + O3 (" ?m1 ") -(0.8388648)> PbSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.8388648) ") + O2 (" (* (/ (+ ?m0 ?m1) 2) 0.8388648) ")")))
)


(defrule ХлоридСвинца_ДигидрогенаМонооксид_ГидроксидХлоридСвинца_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридСвинца) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидХлоридСвинца) (mass (* (/ (+ ?m0 ?m1) 2) 0.3419771))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.3419771))))
   (assert (appendmessagehalt (str-cat "PbCl2 (" ?m0 ") + H2O (" ?m1 ") -(0.3419771)> Pb(OH)Cl (" (* (/ (+ ?m0 ?m1) 2) 0.3419771) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.3419771) ")")))
)


(defrule ХлоридСвинца_Водород_Тепло_Свинец_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридСвинца) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Свинец) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7042825))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7042825))))
   (assert (appendmessagehalt (str-cat "PbCl2 (" ?m0 ") + H2 (" ?m1 ") + t (" ?m2 ") -(0.7042825)> Pb (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7042825) ") + HCl (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7042825) ")")))
)