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


(defrule compose
	(declare (salience 80))
	?e0 <- (element (formula ?e2) (mass ?m0))
	?e1 <- (element (formula ?e2) (mass ?m1))
	(test (neq ?e0 ?e1))
	=>
	(assert (appendmessagehalt (str-cat ?e2 " (" ?m0 ") + " ?e2 " (" ?m1 ")")))
	(retract ?e0)
	(retract ?e1)
	(assert (element (formula ?e2) (mass (+ ?m0 ?m1))))
)


(defrule Электричество_ДигидрогенаМонооксид_Электролиз
   (declare (salience 40))
   (element (formula Электричество) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula Электролиз) (mass (* (/ (+ ?m0 ?m1) 1) 0.702))))
   (assert (appendmessagehalt (str-cat "Электричество (" ?m0 ") + H2O (" ?m1 ") -(0.702)> e (" (* (/ (+ ?m0 ?m1) 1) 0.702) ")")))
)


(defrule Киноварь_СульфидРтути
   (declare (salience 40))
   (element (formula Киноварь) (mass ?m0))
   =>
   (assert (element (formula СульфидРтути) (mass (* (/ ?m0 1) 0.305))))
   (assert (appendmessagehalt (str-cat "Киноварь (" ?m0 ") -(0.305)> HgS (" (* (/ ?m0 1) 0.305) ")")))
)


(defrule Воздух_Кислород_Азот_УглекислыйГаз
   (declare (salience 40))
   (element (formula Воздух) (mass ?m0))
   =>
   (assert (element (formula Кислород) (mass (* (/ ?m0 3) 0.722))))
   (assert (element (formula Азот) (mass (* (/ ?m0 3) 0.722))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ ?m0 3) 0.722))))
   (assert (appendmessagehalt (str-cat "Воздух (" ?m0 ") -(0.722)> O2 (" (* (/ ?m0 3) 0.722) ") + N2 (" (* (/ ?m0 3) 0.722) ") + CO2 (" (* (/ ?m0 3) 0.722) ")")))
)


(defrule ЩавелеваяКислота_ЩавелеваяКислота
   (declare (salience 40))
   (element (formula ЩавелеваяКислота) (mass ?m0))
   =>
   (assert (element (formula ЩавелеваяКислота) (mass (* (/ ?m0 1) 0.312))))
   (assert (appendmessagehalt (str-cat "ЩавелеваяКислота (" ?m0 ") -(0.312)> H2C2O4 (" (* (/ ?m0 1) 0.312) ")")))
)


(defrule Песок_ОксидКремния
   (declare (salience 40))
   (element (formula Песок) (mass ?m0))
   =>
   (assert (element (formula ОксидКремния) (mass (* (/ ?m0 1) 0.353))))
   (assert (appendmessagehalt (str-cat "Песок (" ?m0 ") -(0.353)> SiO2 (" (* (/ ?m0 1) 0.353) ")")))
)


(defrule Известняк_КарбонатКальция
   (declare (salience 40))
   (element (formula Известняк) (mass ?m0))
   =>
   (assert (element (formula КарбонатКальция) (mass (* (/ ?m0 1) 0.930))))
   (assert (appendmessagehalt (str-cat "Известняк (" ?m0 ") -(0.930)> CaCO3 (" (* (/ ?m0 1) 0.930) ")")))
)


(defrule Вода_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Вода) (mass ?m0))
   =>
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ ?m0 1) 0.332))))
   (assert (appendmessagehalt (str-cat "Вода (" ?m0 ") -(0.332)> H2O (" (* (/ ?m0 1) 0.332) ")")))
)


(defrule Боксит_ГидроксидАлюминия_ОксидЖелеза3_ОксидЖелеза
   (declare (salience 40))
   (element (formula Боксит) (mass ?m0))
   =>
   (assert (element (formula ГидроксидАлюминия) (mass (* (/ ?m0 3) 0.325))))
   (assert (element (formula ОксидЖелеза3) (mass (* (/ ?m0 3) 0.325))))
   (assert (element (formula ОксидЖелеза) (mass (* (/ ?m0 3) 0.325))))
   (assert (appendmessagehalt (str-cat "Боксит (" ?m0 ") -(0.325)> Al(OH)3 (" (* (/ ?m0 3) 0.325) ") + Fe2O3 (" (* (/ ?m0 3) 0.325) ") + FeO (" (* (/ ?m0 3) 0.325) ")")))
)


(defrule Магнетит_ОксидЖелеза_ОксидЖелеза3
   (declare (salience 40))
   (element (formula Магнетит) (mass ?m0))
   =>
   (assert (element (formula ОксидЖелеза) (mass (* (/ ?m0 2) 0.446))))
   (assert (element (formula ОксидЖелеза3) (mass (* (/ ?m0 2) 0.446))))
   (assert (appendmessagehalt (str-cat "Магнетит (" ?m0 ") -(0.446)> FeO (" (* (/ ?m0 2) 0.446) ") + Fe2O3 (" (* (/ ?m0 2) 0.446) ")")))
)


(defrule Малахит_Малахит
   (declare (salience 40))
   (element (formula Малахит) (mass ?m0))
   =>
   (assert (element (formula Малахит) (mass (* (/ ?m0 1) 0.888))))
   (assert (appendmessagehalt (str-cat "Малахит (" ?m0 ") -(0.888)> (CuOH)2CO3 (" (* (/ ?m0 1) 0.888) ")")))
)


(defrule Соль_ХлоридНатрия
   (declare (salience 40))
   (element (formula Соль) (mass ?m0))
   =>
   (assert (element (formula ХлоридНатрия) (mass (* (/ ?m0 1) 0.838))))
   (assert (appendmessagehalt (str-cat "Соль (" ?m0 ") -(0.838)> NaCl (" (* (/ ?m0 1) 0.838) ")")))
)


(defrule Барит_СульфатБария
   (declare (salience 40))
   (element (formula Барит) (mass ?m0))
   =>
   (assert (element (formula СульфатБария) (mass (* (/ ?m0 1) 0.512))))
   (assert (appendmessagehalt (str-cat "Барит (" ?m0 ") -(0.512)> BaSO4 (" (* (/ ?m0 1) 0.512) ")")))
)


(defrule Пиролюзит_ОксидМарганца4
   (declare (salience 40))
   (element (formula Пиролюзит) (mass ?m0))
   =>
   (assert (element (formula ОксидМарганца4) (mass (* (/ ?m0 1) 0.467))))
   (assert (appendmessagehalt (str-cat "Пиролюзит (" ?m0 ") -(0.467)> MnO2 (" (* (/ ?m0 1) 0.467) ")")))
)


(defrule Фосфорит_ОксидФосфора
   (declare (salience 40))
   (element (formula Фосфорит) (mass ?m0))
   =>
   (assert (element (formula ОксидФосфора) (mass (* (/ ?m0 1) 0.452))))
   (assert (appendmessagehalt (str-cat "Фосфорит (" ?m0 ") -(0.452)> P4O10 (" (* (/ ?m0 1) 0.452) ")")))
)


(defrule Пирит_СульфидЖелеза
   (declare (salience 40))
   (element (formula Пирит) (mass ?m0))
   =>
   (assert (element (formula СульфидЖелеза) (mass (* (/ ?m0 1) 0.607))))
   (assert (appendmessagehalt (str-cat "Пирит (" ?m0 ") -(0.607)> FeS2 (" (* (/ ?m0 1) 0.607) ")")))
)


(defrule МедныйКолчедан_Халькопирит
   (declare (salience 40))
   (element (formula МедныйКолчедан) (mass ?m0))
   =>
   (assert (element (formula Халькопирит) (mass (* (/ ?m0 1) 0.925))))
   (assert (appendmessagehalt (str-cat "МедныйКолчедан (" ?m0 ") -(0.925)> CuFeS2 (" (* (/ ?m0 1) 0.925) ")")))
)


(defrule Галенит_СульфидСвинца
   (declare (salience 40))
   (element (formula Галенит) (mass ?m0))
   =>
   (assert (element (formula СульфидСвинца) (mass (* (/ ?m0 1) 0.323))))
   (assert (appendmessagehalt (str-cat "Галенит (" ?m0 ") -(0.323)> PbS (" (* (/ ?m0 1) 0.323) ")")))
)


(defrule Уголь_Углерод
   (declare (salience 40))
   (element (formula Уголь) (mass ?m0))
   =>
   (assert (element (formula Углерод) (mass (* (/ ?m0 1) 0.528))))
   (assert (appendmessagehalt (str-cat "Уголь (" ?m0 ") -(0.528)> C (" (* (/ ?m0 1) 0.528) ")")))
)


(defrule Котик_Тепло
   (declare (salience 40))
   (element (formula Котик) (mass ?m0))
   =>
   (assert (element (formula Тепло) (mass (* (/ ?m0 1) 0.639))))
   (assert (appendmessagehalt (str-cat "Котик (" ?m0 ") -(0.639)> t (" (* (/ ?m0 1) 0.639) ")")))
)


(defrule Кислород_Водород_ДигидрогенаМонооксид_Тепло
   (declare (salience 40))
   (element (formula Кислород) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   =>
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.549))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 2) 0.549))))
   (assert (appendmessagehalt (str-cat "O2 (" ?m0 ") + H2 (" ?m1 ") -(0.549)> H2O (" (* (/ (+ ?m0 ?m1) 2) 0.549) ") + t (" (* (/ (+ ?m0 ?m1) 2) 0.549) ")")))
)


(defrule Озон_Кислород_Тепло
   (declare (salience 40))
   (element (formula Озон) (mass ?m0))
   =>
   (assert (element (formula Кислород) (mass (* (/ ?m0 2) 0.389))))
   (assert (element (formula Тепло) (mass (* (/ ?m0 2) 0.389))))
   (assert (appendmessagehalt (str-cat "O3 (" ?m0 ") -(0.389)> O2 (" (* (/ ?m0 2) 0.389) ") + t (" (* (/ ?m0 2) 0.389) ")")))
)


(defrule ДигидрогенаМонооксид_Электролиз_Водород_Кислород
   (declare (salience 40))
   (element (formula ДигидрогенаМонооксид) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   =>
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.678))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 2) 0.678))))
   (assert (appendmessagehalt (str-cat "H2O (" ?m0 ") + e (" ?m1 ") -(0.678)> H2 (" (* (/ (+ ?m0 ?m1) 2) 0.678) ") + O2 (" (* (/ (+ ?m0 ?m1) 2) 0.678) ")")))
)


(defrule Сера_Кислород_МонооксидСеры_ДиоксидСеры_ТриоксидСеры
   (declare (salience 40))
   (element (formula Сера) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula МонооксидСеры) (mass (* (/ (+ ?m0 ?m1) 3) 0.796))))
   (assert (element (formula ДиоксидСеры) (mass (* (/ (+ ?m0 ?m1) 3) 0.796))))
   (assert (element (formula ТриоксидСеры) (mass (* (/ (+ ?m0 ?m1) 3) 0.796))))
   (assert (appendmessagehalt (str-cat "S (" ?m0 ") + O2 (" ?m1 ") -(0.796)> SO (" (* (/ (+ ?m0 ?m1) 3) 0.796) ") + SO2 (" (* (/ (+ ?m0 ?m1) 3) 0.796) ") + SO3 (" (* (/ (+ ?m0 ?m1) 3) 0.796) ")")))
)


(defrule Фтор_Кислород_ОксидФтора
   (declare (salience 40))
   (element (formula Фтор) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидФтора) (mass (* (/ (+ ?m0 ?m1) 1) 0.688))))
   (assert (appendmessagehalt (str-cat "F2 (" ?m0 ") + O2 (" ?m1 ") -(0.688)> F2O (" (* (/ (+ ?m0 ?m1) 1) 0.688) ")")))
)


(defrule Азот_Кислород_ОксидАзота1_ОксидАзота2_ОксидАзота3_ОксидАзота4_ОксидАзота5
   (declare (salience 40))
   (element (formula Азот) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидАзота1) (mass (* (/ (+ ?m0 ?m1) 5) 0.642))))
   (assert (element (formula ОксидАзота2) (mass (* (/ (+ ?m0 ?m1) 5) 0.642))))
   (assert (element (formula ОксидАзота3) (mass (* (/ (+ ?m0 ?m1) 5) 0.642))))
   (assert (element (formula ОксидАзота4) (mass (* (/ (+ ?m0 ?m1) 5) 0.642))))
   (assert (element (formula ОксидАзота5) (mass (* (/ (+ ?m0 ?m1) 5) 0.642))))
   (assert (appendmessagehalt (str-cat "N2 (" ?m0 ") + O2 (" ?m1 ") -(0.642)> N2O (" (* (/ (+ ?m0 ?m1) 5) 0.642) ") + NO (" (* (/ (+ ?m0 ?m1) 5) 0.642) ") + N2O3 (" (* (/ (+ ?m0 ?m1) 5) 0.642) ") + NO2 (" (* (/ (+ ?m0 ?m1) 5) 0.642) ") + N2O5 (" (* (/ (+ ?m0 ?m1) 5) 0.642) ")")))
)


(defrule ОксидАзота2_Кислород_ОксидАзота4
   (declare (salience 40))
   (element (formula ОксидАзота2) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидАзота4) (mass (* (/ (+ ?m0 ?m1) 1) 0.812))))
   (assert (appendmessagehalt (str-cat "NO (" ?m0 ") + O2 (" ?m1 ") -(0.812)> NO2 (" (* (/ (+ ?m0 ?m1) 1) 0.812) ")")))
)


(defrule Углерод_Кислород_УгарныйГаз_УглекислыйГаз_Тепло
   (declare (salience 40))
   (element (formula Углерод) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula УгарныйГаз) (mass (* (/ (+ ?m0 ?m1) 3) 0.549))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 3) 0.549))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 3) 0.549))))
   (assert (appendmessagehalt (str-cat "C (" ?m0 ") + O2 (" ?m1 ") -(0.549)> CO (" (* (/ (+ ?m0 ?m1) 3) 0.549) ") + CO2 (" (* (/ (+ ?m0 ?m1) 3) 0.549) ") + t (" (* (/ (+ ?m0 ?m1) 3) 0.549) ")")))
)


(defrule Натрий_Кислород_ОксидНатрия_Тепло
   (declare (salience 40))
   (element (formula Натрий) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.948))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 2) 0.948))))
   (assert (appendmessagehalt (str-cat "Na (" ?m0 ") + O2 (" ?m1 ") -(0.948)> NaO (" (* (/ (+ ?m0 ?m1) 2) 0.948) ") + t (" (* (/ (+ ?m0 ?m1) 2) 0.948) ")")))
)


(defrule Калий_Кислород_ОксидКалия_Тепло
   (declare (salience 40))
   (element (formula Калий) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.811))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 2) 0.811))))
   (assert (appendmessagehalt (str-cat "K (" ?m0 ") + O2 (" ?m1 ") -(0.811)> K2O (" (* (/ (+ ?m0 ?m1) 2) 0.811) ") + t (" (* (/ (+ ?m0 ?m1) 2) 0.811) ")")))
)


(defrule ТриоксидСеры_ДигидрогенаМонооксид_СернаяКислота
   (declare (salience 40))
   (element (formula ТриоксидСеры) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula СернаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.385))))
   (assert (appendmessagehalt (str-cat "SO3 (" ?m0 ") + H2O (" ?m1 ") -(0.385)> H2SO4 (" (* (/ (+ ?m0 ?m1) 1) 0.385) ")")))
)


(defrule СернаяКислота_Электролиз_ПероксодисернаяКислота_Водород
   (declare (salience 40))
   (element (formula СернаяКислота) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   =>
   (assert (element (formula ПероксодисернаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.358))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.358))))
   (assert (appendmessagehalt (str-cat "H2SO4 (" ?m0 ") + e (" ?m1 ") -(0.358)> H2S2O8 (" (* (/ (+ ?m0 ?m1) 2) 0.358) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.358) ")")))
)


(defrule ПероксодисернаяКислота_ДигидрогенаМонооксид_ПероксидВодорода_СернаяКислота
   (declare (salience 40))
   (element (formula ПероксодисернаяКислота) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ПероксидВодорода) (mass (* (/ (+ ?m0 ?m1) 2) 0.871))))
   (assert (element (formula СернаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.871))))
   (assert (appendmessagehalt (str-cat "H2S2O8 (" ?m0 ") + H2O (" ?m1 ") -(0.871)> H2O2 (" (* (/ (+ ?m0 ?m1) 2) 0.871) ") + H2SO4 (" (* (/ (+ ?m0 ?m1) 2) 0.871) ")")))
)


(defrule СолянаяКислота_ДиоксидСеры_ХлорсульфоноваяКислота
   (declare (salience 40))
   (element (formula СолянаяКислота) (mass ?m0))
   (element (formula ДиоксидСеры) (mass ?m1))
   =>
   (assert (element (formula ХлорсульфоноваяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.347))))
   (assert (appendmessagehalt (str-cat "HCl (" ?m0 ") + SO2 (" ?m1 ") -(0.347)> HSO3Cl (" (* (/ (+ ?m0 ?m1) 1) 0.347) ")")))
)


(defrule Водород_Хлор_СолянаяКислота
   (declare (salience 40))
   (element (formula Водород) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.725))))
   (assert (appendmessagehalt (str-cat "H2 (" ?m0 ") + Cl2 (" ?m1 ") -(0.725)> HCl (" (* (/ (+ ?m0 ?m1) 1) 0.725) ")")))
)


(defrule ГидроксидНатрия_Хлор_ХлоридНатрия_ГипохлоритНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидНатрия) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.529))))
   (assert (element (formula ГипохлоритНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.529))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.529))))
   (assert (appendmessagehalt (str-cat "NaOH (" ?m0 ") + Cl2 (" ?m1 ") -(0.529)> NaCl (" (* (/ (+ ?m0 ?m1) 3) 0.529) ") + NaOCl (" (* (/ (+ ?m0 ?m1) 3) 0.529) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.529) ")")))
)


(defrule Натрий_ДигидрогенаМонооксид_ГидроксидНатрия_Водород
   (declare (salience 40))
   (element (formula Натрий) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.786))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.786))))
   (assert (appendmessagehalt (str-cat "Na (" ?m0 ") + H2O (" ?m1 ") -(0.786)> NaOH (" (* (/ (+ ?m0 ?m1) 2) 0.786) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.786) ")")))
)


(defrule ХлоридНатрия_СернаяКислота_ГидросульфатНатрия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридНатрия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula ГидросульфатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.664))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.664))))
   (assert (appendmessagehalt (str-cat "NaCl (" ?m0 ") + H2SO4 (" ?m1 ") -(0.664)> NaHSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.664) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.664) ")")))
)


(defrule Калий_ДигидрогенаМонооксид_ГидроксидКалия
   (declare (salience 40))
   (element (formula Калий) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидКалия) (mass (* (/ (+ ?m0 ?m1) 1) 0.775))))
   (assert (appendmessagehalt (str-cat "K (" ?m0 ") + H2O (" ?m1 ") -(0.775)> KOH (" (* (/ (+ ?m0 ?m1) 1) 0.775) ")")))
)


(defrule АзотнаяКислота_Свет_ОксидАзота2_ДигидрогенаМонооксид_Кислород
   (declare (salience 40))
   (element (formula АзотнаяКислота) (mass ?m0))
   (element (formula Свет) (mass ?m1))
   =>
   (assert (element (formula ОксидАзота2) (mass (* (/ (+ ?m0 ?m1) 3) 0.482))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.482))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 3) 0.482))))
   (assert (appendmessagehalt (str-cat "HNO3 (" ?m0 ") + hv (" ?m1 ") -(0.482)> NO (" (* (/ (+ ?m0 ?m1) 3) 0.482) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.482) ") + O2 (" (* (/ (+ ?m0 ?m1) 3) 0.482) ")")))
)


(defrule Метан_Кислород_ОксидАзота2_ДигидрогенаМонооксид_Тепло
   (declare (salience 40))
   (element (formula Метан) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидАзота2) (mass (* (/ (+ ?m0 ?m1) 3) 0.452))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.452))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 3) 0.452))))
   (assert (appendmessagehalt (str-cat "NH3 (" ?m0 ") + O2 (" ?m1 ") -(0.452)> NO (" (* (/ (+ ?m0 ?m1) 3) 0.452) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.452) ") + t (" (* (/ (+ ?m0 ?m1) 3) 0.452) ")")))
)


(defrule ОксидАзота4_Кислород_ДигидрогенаМонооксид_АзотнаяКислота_Тепло
   (declare (salience 40))
   (element (formula ОксидАзота4) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula ДигидрогенаМонооксид) (mass ?m2))
   =>
   (assert (element (formula АзотнаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.310))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.310))))
   (assert (appendmessagehalt (str-cat "NO2 (" ?m0 ") + O2 (" ?m1 ") + H2O (" ?m2 ") -(0.310)> HNO3 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.310) ") + t (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.310) ")")))
)


(defrule Азот_Водород_Метан_Тепло
   (declare (salience 40))
   (element (formula Азот) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   =>
   (assert (element (formula Метан) (mass (* (/ (+ ?m0 ?m1) 2) 0.411))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 2) 0.411))))
   (assert (appendmessagehalt (str-cat "N2 (" ?m0 ") + H2 (" ?m1 ") -(0.411)> NH3 (" (* (/ (+ ?m0 ?m1) 2) 0.411) ") + t (" (* (/ (+ ?m0 ?m1) 2) 0.411) ")")))
)


(defrule Метан_Тепло_Азот_Водород
   (declare (salience 40))
   (element (formula Метан) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula Азот) (mass (* (/ (+ ?m0 ?m1) 2) 0.841))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.841))))
   (assert (appendmessagehalt (str-cat "NH3 (" ?m0 ") + t (" ?m1 ") -(0.841)> N2 (" (* (/ (+ ?m0 ?m1) 2) 0.841) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.841) ")")))
)


(defrule ДигидрогенаМонооксид_УглекислыйГаз_УгольнаяКислота
   (declare (salience 40))
   (element (formula ДигидрогенаМонооксид) (mass ?m0))
   (element (formula УглекислыйГаз) (mass ?m1))
   =>
   (assert (element (formula УгольнаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.374))))
   (assert (appendmessagehalt (str-cat "H2O (" ?m0 ") + CO2 (" ?m1 ") -(0.374)> H2CO3 (" (* (/ (+ ?m0 ?m1) 1) 0.374) ")")))
)


(defrule УгольнаяКислота_ДигидрогенаМонооксид_УглекислыйГаз
   (declare (salience 40))
   (element (formula УгольнаяКислота) (mass ?m0))
   =>
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ ?m0 2) 0.932))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ ?m0 2) 0.932))))
   (assert (appendmessagehalt (str-cat "H2CO3 (" ?m0 ") -(0.932)> H2O (" (* (/ ?m0 2) 0.932) ") + CO2 (" (* (/ ?m0 2) 0.932) ")")))
)


(defrule КарбонатНатрия_СолянаяКислота_ХлоридНатрия_УгольнаяКислота
   (declare (salience 40))
   (element (formula КарбонатНатрия) (mass ?m0))
   (element (formula СолянаяКислота) (mass ?m1))
   =>
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.934))))
   (assert (element (formula УгольнаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.934))))
   (assert (appendmessagehalt (str-cat "Na2CO3 (" ?m0 ") + HCl (" ?m1 ") -(0.934)> NaCl (" (* (/ (+ ?m0 ?m1) 2) 0.934) ") + H2CO3 (" (* (/ (+ ?m0 ?m1) 2) 0.934) ")")))
)


(defrule СиликатНатрия_СолянаяКислота_МетакремниеваяКислота_ХлоридНатрия
   (declare (salience 40))
   (element (formula СиликатНатрия) (mass ?m0))
   (element (formula СолянаяКислота) (mass ?m1))
   =>
   (assert (element (formula МетакремниеваяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.615))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.615))))
   (assert (appendmessagehalt (str-cat "Na2SiO3 (" ?m0 ") + HCl (" ?m1 ") -(0.615)> H2SiO3 (" (* (/ (+ ?m0 ?m1) 2) 0.615) ") + NaCl (" (* (/ (+ ?m0 ?m1) 2) 0.615) ")")))
)


(defrule Дихлорсилан_ДигидрогенаМонооксид_СернистаяКислота_СолянаяКислота_Водород
   (declare (salience 40))
   (element (formula Дихлорсилан) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula СернистаяКислота) (mass (* (/ (+ ?m0 ?m1) 3) 0.518))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 3) 0.518))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 3) 0.518))))
   (assert (appendmessagehalt (str-cat "SiH2Cl2 (" ?m0 ") + H2O (" ?m1 ") -(0.518)> H2SO3 (" (* (/ (+ ?m0 ?m1) 3) 0.518) ") + HCl (" (* (/ (+ ?m0 ?m1) 3) 0.518) ") + H2 (" (* (/ (+ ?m0 ?m1) 3) 0.518) ")")))
)


(defrule ОксидАзота3_ДигидрогенаМонооксид_АзотистаяКислота
   (declare (salience 40))
   (element (formula ОксидАзота3) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula АзотистаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.342))))
   (assert (appendmessagehalt (str-cat "N2O3 (" ?m0 ") + H2O (" ?m1 ") -(0.342)> HNO2 (" (* (/ (+ ?m0 ?m1) 1) 0.342) ")")))
)


(defrule ОксидАзота4_ДигидрогенаМонооксид_АзотнаяКислота_АзотистаяКислота
   (declare (salience 40))
   (element (formula ОксидАзота4) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula АзотнаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.760))))
   (assert (element (formula АзотистаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.760))))
   (assert (appendmessagehalt (str-cat "NO2 (" ?m0 ") + H2O (" ?m1 ") -(0.760)> HNO3 (" (* (/ (+ ?m0 ?m1) 2) 0.760) ") + HNO2 (" (* (/ (+ ?m0 ?m1) 2) 0.760) ")")))
)


(defrule Фосфор_АзотнаяКислота_ДигидрогенаМонооксид_ОртофосфорнаяКислота_ОксидАзота2
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula АзотнаяКислота) (mass ?m1))
   (element (formula ДигидрогенаМонооксид) (mass ?m2))
   =>
   (assert (element (formula ОртофосфорнаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.517))))
   (assert (element (formula ОксидАзота2) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.517))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + HNO3 (" ?m1 ") + H2O (" ?m2 ") -(0.517)> H3PO4 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.517) ") + NO (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.517) ")")))
)


(defrule БелыйФосфор_Кислород_Тепло_ОксидФосфора
   (declare (salience 40))
   (element (formula БелыйФосфор) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидФосфора) (mass (* (/ (+ ?m0 ?m1 ?m2) 1) 0.809))))
   (assert (appendmessagehalt (str-cat "P4 (" ?m0 ") + O2 (" ?m1 ") + t (" ?m2 ") -(0.809)> P4O10 (" (* (/ (+ ?m0 ?m1 ?m2) 1) 0.809) ")")))
)


(defrule ОксидФосфора_ДигидрогенаМонооксид_ОртофосфорнаяКислота
   (declare (salience 40))
   (element (formula ОксидФосфора) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ОртофосфорнаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.789))))
   (assert (appendmessagehalt (str-cat "P4O10 (" ?m0 ") + H2O (" ?m1 ") -(0.789)> H3PO4 (" (* (/ (+ ?m0 ?m1) 1) 0.789) ")")))
)


(defrule ОксидФосфора3_ДигидрогенаМонооксид_ФосфористаяКислота
   (declare (salience 40))
   (element (formula ОксидФосфора3) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ФосфористаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.849))))
   (assert (appendmessagehalt (str-cat "P2O3 (" ?m0 ") + H2O (" ?m1 ") -(0.849)> H3PO3 (" (* (/ (+ ?m0 ?m1) 1) 0.849) ")")))
)


(defrule ХлоридФосфора_ДигидрогенаМонооксид_ФосфористаяКислота_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридФосфора) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ФосфористаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.865))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.865))))
   (assert (appendmessagehalt (str-cat "PCl3 (" ?m0 ") + H2O (" ?m1 ") -(0.865)> H3PO3 (" (* (/ (+ ?m0 ?m1) 2) 0.865) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.865) ")")))
)


(defrule ГидрофосфатКалия_СолянаяКислота_ХлоридКалия_ФосфористаяКислота
   (declare (salience 40))
   (element (formula ГидрофосфатКалия) (mass ?m0))
   (element (formula СолянаяКислота) (mass ?m1))
   =>
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.344))))
   (assert (element (formula ФосфористаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.344))))
   (assert (appendmessagehalt (str-cat "K2HPO3 (" ?m0 ") + HCl (" ?m1 ") -(0.344)> KCl (" (* (/ (+ ?m0 ?m1) 2) 0.344) ") + H3PO3 (" (* (/ (+ ?m0 ?m1) 2) 0.344) ")")))
)


(defrule ОксидХрома_ДигидрогенаМонооксид_ХромоваяКислота_ДихромоваяКислота
   (declare (salience 40))
   (element (formula ОксидХрома) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ХромоваяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.466))))
   (assert (element (formula ДихромоваяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.466))))
   (assert (appendmessagehalt (str-cat "CrO3 (" ?m0 ") + H2O (" ?m1 ") -(0.466)> H2CrO4 (" (* (/ (+ ?m0 ?m1) 2) 0.466) ") + H2Cr2O7 (" (* (/ (+ ?m0 ?m1) 2) 0.466) ")")))
)


(defrule Хлор_ДигидрогенаМонооксид_ХлорноватистаяКислота_СолянаяКислота
   (declare (salience 40))
   (element (formula Хлор) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ХлорноватистаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.614))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.614))))
   (assert (appendmessagehalt (str-cat "Cl2 (" ?m0 ") + H2O (" ?m1 ") -(0.614)> HClO (" (* (/ (+ ?m0 ?m1) 2) 0.614) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.614) ")")))
)


(defrule ОксидХлора_ДигидрогенаМонооксид_ХлорноватистаяКислота
   (declare (salience 40))
   (element (formula ОксидХлора) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ХлорноватистаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.588))))
   (assert (appendmessagehalt (str-cat "Cl2O (" ?m0 ") + H2O (" ?m1 ") -(0.588)> HClO (" (* (/ (+ ?m0 ?m1) 1) 0.588) ")")))
)


(defrule ОксидХлора_ПероксидВодорода_ГидроксидНатрия_ХлоритНатрия_Кислород_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидХлора) (mass ?m0))
   (element (formula ПероксидВодорода) (mass ?m1))
   (element (formula ГидроксидНатрия) (mass ?m2))
   =>
   (assert (element (formula ХлоритНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.470))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.470))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.470))))
   (assert (appendmessagehalt (str-cat "ClO2 (" ?m0 ") + H2O2 (" ?m1 ") + NaOH (" ?m2 ") -(0.470)> NaClO2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.470) ") + O2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.470) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.470) ")")))
)


(defrule ГипохлоритБария_СернаяКислота_СульфатБария_ХлористаяКислота
   (declare (salience 40))
   (element (formula ГипохлоритБария) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula СульфатБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.726))))
   (assert (element (formula ХлористаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.726))))
   (assert (appendmessagehalt (str-cat "Ba(ClO2)2 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.726)> BaSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.726) ") + HClO2 (" (* (/ (+ ?m0 ?m1) 2) 0.726) ")")))
)


(defrule ХлоратБария_СернаяКислота_СульфатБария_ХлорноватаяКислота
   (declare (salience 40))
   (element (formula ХлоратБария) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula СульфатБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.447))))
   (assert (element (formula ХлорноватаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.447))))
   (assert (appendmessagehalt (str-cat "Ba(ClO3)2 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.447)> BaSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.447) ") + HClO3 (" (* (/ (+ ?m0 ?m1) 2) 0.447) ")")))
)


(defrule ПерхлоратКалия_СернаяКислота_ГидросульфатКалия_ХлорнаяКислота
   (declare (salience 40))
   (element (formula ПерхлоратКалия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula ГидросульфатКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.377))))
   (assert (element (formula ХлорнаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.377))))
   (assert (appendmessagehalt (str-cat "KClO4 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.377)> KHSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.377) ") + HClO4 (" (* (/ (+ ?m0 ?m1) 2) 0.377) ")")))
)


(defrule ПерманганатБария_СернаяКислота_МарганцоваяКислота_СульфатБария
   (declare (salience 40))
   (element (formula ПерманганатБария) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula МарганцоваяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.752))))
   (assert (element (formula СульфатБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.752))))
   (assert (appendmessagehalt (str-cat "Ba(MnO4)2 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.752)> HMnO4 (" (* (/ (+ ?m0 ?m1) 2) 0.752) ") + BaSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.752) ")")))
)


(defrule ОксидМарганца7_ДигидрогенаМонооксид_МарганцоваяКислота
   (declare (salience 40))
   (element (formula ОксидМарганца7) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula МарганцоваяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.454))))
   (assert (appendmessagehalt (str-cat "Mn2O7 (" ?m0 ") + H2O (" ?m1 ") -(0.454)> HMnO4 (" (* (/ (+ ?m0 ?m1) 1) 0.454) ")")))
)


(defrule СульфатНатрия_Углерод_СульфидНатрия_УглекислыйГаз
   (declare (salience 40))
   (element (formula СульфатНатрия) (mass ?m0))
   (element (formula Углерод) (mass ?m1))
   =>
   (assert (element (formula СульфидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.545))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.545))))
   (assert (appendmessagehalt (str-cat "Na2SO4 (" ?m0 ") + C (" ?m1 ") -(0.545)> Na2S (" (* (/ (+ ?m0 ?m1) 2) 0.545) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.545) ")")))
)


(defrule СульфидНатрия_КарбонатКальция_КарбонатНатрия_СульфидКальция
   (declare (salience 40))
   (element (formula СульфидНатрия) (mass ?m0))
   (element (formula КарбонатКальция) (mass ?m1))
   =>
   (assert (element (formula КарбонатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.405))))
   (assert (element (formula СульфидКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.405))))
   (assert (appendmessagehalt (str-cat "Na2S (" ?m0 ") + CaCO3 (" ?m1 ") -(0.405)> Na2CO3 (" (* (/ (+ ?m0 ?m1) 2) 0.405) ") + CaS (" (* (/ (+ ?m0 ?m1) 2) 0.405) ")")))
)


(defrule ХлоридНатрия_СернаяКислота_СульфатНатрия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридНатрия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula СульфатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.831))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.831))))
   (assert (appendmessagehalt (str-cat "NaCl (" ?m0 ") + H2SO4 (" ?m1 ") -(0.831)> Na2SO4 (" (* (/ (+ ?m0 ?m1) 2) 0.831) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.831) ")")))
)


(defrule Метан_УглекислыйГаз_ДигидрогенаМонооксид_ХлоридНатрия_ГидрокарбонатНатрия_ХлоридАммония
   (declare (salience 40))
   (element (formula Метан) (mass ?m0))
   (element (formula УглекислыйГаз) (mass ?m1))
   (element (formula ДигидрогенаМонооксид) (mass ?m2))
   (element (formula ХлоридНатрия) (mass ?m3))
   =>
   (assert (element (formula ГидрокарбонатНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.695))))
   (assert (element (formula ХлоридАммония) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.695))))
   (assert (appendmessagehalt (str-cat "NH3 (" ?m0 ") + CO2 (" ?m1 ") + H2O (" ?m2 ") + NaCl (" ?m3 ") -(0.695)> NaHCO3 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.695) ") + HN4Cl (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.695) ")")))
)


(defrule ГидрокарбонатНатрия_Тепло_КарбонатНатрия_ДигидрогенаМонооксид_УглекислыйГаз
   (declare (salience 40))
   (element (formula ГидрокарбонатНатрия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula КарбонатНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.486))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.486))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 3) 0.486))))
   (assert (appendmessagehalt (str-cat "NaHCO3 (" ?m0 ") + t (" ?m1 ") -(0.486)> Na2CO3 (" (* (/ (+ ?m0 ?m1) 3) 0.486) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.486) ") + CO2 (" (* (/ (+ ?m0 ?m1) 3) 0.486) ")")))
)


(defrule ОксидКремния_ГидроксидНатрия_СиликатНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидКремния) (mass ?m0))
   (element (formula ГидроксидНатрия) (mass ?m1))
   =>
   (assert (element (formula СиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.813))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.813))))
   (assert (appendmessagehalt (str-cat "SiO2 (" ?m0 ") + NaOH (" ?m1 ") -(0.813)> Na2SiO3 (" (* (/ (+ ?m0 ?m1) 2) 0.813) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.813) ")")))
)


(defrule ОксидКремния_КарбонатНатрия_СиликатНатрия_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидКремния) (mass ?m0))
   (element (formula КарбонатНатрия) (mass ?m1))
   =>
   (assert (element (formula СиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.813))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.813))))
   (assert (appendmessagehalt (str-cat "SiO2 (" ?m0 ") + Na2CO3 (" ?m1 ") -(0.813)> Na2SiO3 (" (* (/ (+ ?m0 ?m1) 2) 0.813) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.813) ")")))
)


(defrule ОртосиликатНатрия_Тепло_СиликатНатрия_ОксидНатрия
   (declare (salience 40))
   (element (formula ОртосиликатНатрия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula СиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.366))))
   (assert (element (formula ОксидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.366))))
   (assert (appendmessagehalt (str-cat "Na4SiO4 (" ?m0 ") + t (" ?m1 ") -(0.366)> Na2SiO3 (" (* (/ (+ ?m0 ?m1) 2) 0.366) ") + Na2O (" (* (/ (+ ?m0 ?m1) 2) 0.366) ")")))
)


(defrule СлоридАммония_ГидроксидНатрия_Метан_ХлоридНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СлоридАммония) (mass ?m0))
   (element (formula ГидроксидНатрия) (mass ?m1))
   =>
   (assert (element (formula Метан) (mass (* (/ (+ ?m0 ?m1) 3) 0.914))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.914))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.914))))
   (assert (appendmessagehalt (str-cat "NH4Cl (" ?m0 ") + NaOH (" ?m1 ") -(0.914)> NH3 (" (* (/ (+ ?m0 ?m1) 3) 0.914) ") + NaCl (" (* (/ (+ ?m0 ?m1) 3) 0.914) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.914) ")")))
)


(defrule МетафосфорнаяКислота_Углерод_БелыйФосфор_ДигидрогенаМонооксид_УгарныйГаз
   (declare (salience 40))
   (element (formula МетафосфорнаяКислота) (mass ?m0))
   (element (formula Углерод) (mass ?m1))
   =>
   (assert (element (formula БелыйФосфор) (mass (* (/ (+ ?m0 ?m1) 3) 0.792))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.792))))
   (assert (element (formula УгарныйГаз) (mass (* (/ (+ ?m0 ?m1) 3) 0.792))))
   (assert (appendmessagehalt (str-cat "HPO3 (" ?m0 ") + C (" ?m1 ") -(0.792)> P4 (" (* (/ (+ ?m0 ?m1) 3) 0.792) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.792) ") + CO (" (* (/ (+ ?m0 ?m1) 3) 0.792) ")")))
)


(defrule Фосфор_Кислород_ОксидФосфора5_ОксидФосфора3
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидФосфора5) (mass (* (/ (+ ?m0 ?m1) 2) 0.928))))
   (assert (element (formula ОксидФосфора3) (mass (* (/ (+ ?m0 ?m1) 2) 0.928))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + O2 (" ?m1 ") -(0.928)> P2O5 (" (* (/ (+ ?m0 ?m1) 2) 0.928) ") + P2O3 (" (* (/ (+ ?m0 ?m1) 2) 0.928) ")")))
)


(defrule Фосфор_Кальций_ФосфидКальция
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula Кальций) (mass ?m1))
   =>
   (assert (element (formula ФосфидКальция) (mass (* (/ (+ ?m0 ?m1) 1) 0.786))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + Ca (" ?m1 ") -(0.786)> Ca3P2 (" (* (/ (+ ?m0 ?m1) 1) 0.786) ")")))
)


(defrule Фосфор_Сера_СульфидФосфора
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula Сера) (mass ?m1))
   =>
   (assert (element (formula СульфидФосфора) (mass (* (/ (+ ?m0 ?m1) 1) 0.721))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + S (" ?m1 ") -(0.721)> P2S3 (" (* (/ (+ ?m0 ?m1) 1) 0.721) ")")))
)


(defrule Фосфор_Хлор_ХлоридФосфора_ХлоридФосфора
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ХлоридФосфора) (mass (* (/ (+ ?m0 ?m1) 2) 0.706))))
   (assert (element (formula ХлоридФосфора) (mass (* (/ (+ ?m0 ?m1) 2) 0.706))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + Cl2 (" ?m1 ") -(0.706)> PCl3 (" (* (/ (+ ?m0 ?m1) 2) 0.706) ") + PCl5 (" (* (/ (+ ?m0 ?m1) 2) 0.706) ")")))
)


(defrule Фосфор_ДигидрогенаМонооксид_Тепло_Фосфин_ОртофосфорнаяКислота
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Фосфин) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.657))))
   (assert (element (formula ОртофосфорнаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.657))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + H2O (" ?m1 ") + t (" ?m2 ") -(0.657)> PH3 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.657) ") + H3PO4 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.657) ")")))
)


(defrule Фосфор_ДигидрогенаМонооксид_Тепло_ОртофосфорнаяКислота_Водород
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОртофосфорнаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.496))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.496))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + H2O (" ?m1 ") + t (" ?m2 ") -(0.496)> H3PO4 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.496) ") + H2 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.496) ")")))
)


(defrule БелыйФосфор_Тепло_Фосфор
   (declare (salience 40))
   (element (formula БелыйФосфор) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula Фосфор) (mass (* (/ (+ ?m0 ?m1) 1) 0.330))))
   (assert (appendmessagehalt (str-cat "P4 (" ?m0 ") + t (" ?m1 ") -(0.330)> P (" (* (/ (+ ?m0 ?m1) 1) 0.330) ")")))
)


(defrule БелыйФосфор_Свет_Фосфор
   (declare (salience 40))
   (element (formula БелыйФосфор) (mass ?m0))
   (element (formula Свет) (mass ?m1))
   =>
   (assert (element (formula Фосфор) (mass (* (/ (+ ?m0 ?m1) 1) 0.905))))
   (assert (appendmessagehalt (str-cat "P4 (" ?m0 ") + hv (" ?m1 ") -(0.905)> P (" (* (/ (+ ?m0 ?m1) 1) 0.905) ")")))
)


(defrule БелыйФосфор_ОксидАзота1_ОксидФосфора_Азот
   (declare (salience 40))
   (element (formula БелыйФосфор) (mass ?m0))
   (element (formula ОксидАзота1) (mass ?m1))
   =>
   (assert (element (formula ОксидФосфора) (mass (* (/ (+ ?m0 ?m1) 2) 0.351))))
   (assert (element (formula Азот) (mass (* (/ (+ ?m0 ?m1) 2) 0.351))))
   (assert (appendmessagehalt (str-cat "P4 (" ?m0 ") + N2O (" ?m1 ") -(0.351)> P4O5 (" (* (/ (+ ?m0 ?m1) 2) 0.351) ") + N2 (" (* (/ (+ ?m0 ?m1) 2) 0.351) ")")))
)


(defrule БелыйФосфор_УглекислыйГаз_ОксидФосфора_УгарныйГаз
   (declare (salience 40))
   (element (formula БелыйФосфор) (mass ?m0))
   (element (formula УглекислыйГаз) (mass ?m1))
   =>
   (assert (element (formula ОксидФосфора) (mass (* (/ (+ ?m0 ?m1) 2) 0.818))))
   (assert (element (formula УгарныйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.818))))
   (assert (appendmessagehalt (str-cat "P4 (" ?m0 ") + CO2 (" ?m1 ") -(0.818)> P4O5 (" (* (/ (+ ?m0 ?m1) 2) 0.818) ") + CO (" (* (/ (+ ?m0 ?m1) 2) 0.818) ")")))
)


(defrule ДихроматНатрия_СернаяКислота_ОксидХрома_СульфатНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ДихроматНатрия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula ОксидХрома) (mass (* (/ (+ ?m0 ?m1) 3) 0.498))))
   (assert (element (formula СульфатНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.498))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.498))))
   (assert (appendmessagehalt (str-cat "Na2Cr2O7 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.498)> CrO3 (" (* (/ (+ ?m0 ?m1) 3) 0.498) ") + Na2SO4 (" (* (/ (+ ?m0 ?m1) 3) 0.498) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.498) ")")))
)


(defrule ОксидРтути_Хлор_ГипохлоридРтути_ОксидХлора
   (declare (salience 40))
   (element (formula ОксидРтути) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ГипохлоридРтути) (mass (* (/ (+ ?m0 ?m1) 2) 0.382))))
   (assert (element (formula ОксидХлора) (mass (* (/ (+ ?m0 ?m1) 2) 0.382))))
   (assert (appendmessagehalt (str-cat "HgO (" ?m0 ") + Cl2 (" ?m1 ") -(0.382)> Hg2OCl2 (" (* (/ (+ ?m0 ?m1) 2) 0.382) ") + Cl2O (" (* (/ (+ ?m0 ?m1) 2) 0.382) ")")))
)


(defrule ОксидРтути_Хлор_ХлоридРтути_ОксидХлора
   (declare (salience 40))
   (element (formula ОксидРтути) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ХлоридРтути) (mass (* (/ (+ ?m0 ?m1) 2) 0.447))))
   (assert (element (formula ОксидХлора) (mass (* (/ (+ ?m0 ?m1) 2) 0.447))))
   (assert (appendmessagehalt (str-cat "HgO (" ?m0 ") + Cl2 (" ?m1 ") -(0.447)> HgCl2 (" (* (/ (+ ?m0 ?m1) 2) 0.447) ") + Cl2O (" (* (/ (+ ?m0 ?m1) 2) 0.447) ")")))
)


(defrule Хлор_КарбонатНатрия_ДигидрогенаМонооксид_ГидрокарбонатНатрия_ХлоридНатрия_ОксидХлора
   (declare (salience 40))
   (element (formula Хлор) (mass ?m0))
   (element (formula КарбонатНатрия) (mass ?m1))
   (element (formula ДигидрогенаМонооксид) (mass ?m2))
   =>
   (assert (element (formula ГидрокарбонатНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.810))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.810))))
   (assert (element (formula ОксидХлора) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.810))))
   (assert (appendmessagehalt (str-cat "Cl2 (" ?m0 ") + Na2CO3 (" ?m1 ") + H2O (" ?m2 ") -(0.810)> NaHCO3 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.810) ") + NaCl (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.810) ") + Cl2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.810) ")")))
)


(defrule ХлоратКалия_ЩавелеваяКислота_ОксидХлора_КарбонатКалия_УглекислыйГаз_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ХлоратКалия) (mass ?m0))
   (element (formula ЩавелеваяКислота) (mass ?m1))
   =>
   (assert (element (formula ОксидХлора) (mass (* (/ (+ ?m0 ?m1) 4) 0.485))))
   (assert (element (formula КарбонатКалия) (mass (* (/ (+ ?m0 ?m1) 4) 0.485))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 4) 0.485))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 4) 0.485))))
   (assert (appendmessagehalt (str-cat "KClO3 (" ?m0 ") + H2C2O4 (" ?m1 ") -(0.485)> ClO2 (" (* (/ (+ ?m0 ?m1) 4) 0.485) ") + K2CO3 (" (* (/ (+ ?m0 ?m1) 4) 0.485) ") + CO2 (" (* (/ (+ ?m0 ?m1) 4) 0.485) ") + H2O (" (* (/ (+ ?m0 ?m1) 4) 0.485) ")")))
)


(defrule ХлоратНатрия_ДиоксидСеры_СернаяКислота_ГидросульфатНатрия_ОксидХлора
   (declare (salience 40))
   (element (formula ХлоратНатрия) (mass ?m0))
   (element (formula ДиоксидСеры) (mass ?m1))
   (element (formula СернаяКислота) (mass ?m2))
   =>
   (assert (element (formula ГидросульфатНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.620))))
   (assert (element (formula ОксидХлора) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.620))))
   (assert (appendmessagehalt (str-cat "NaClO3 (" ?m0 ") + SO2 (" ?m1 ") + H2SO4 (" ?m2 ") -(0.620)> NaHSO4 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.620) ") + ClO2 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.620) ")")))
)


(defrule ГидроксидБария_Хлор_ГипохлоритБария_ХлоридБария_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидБария) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ГипохлоритБария) (mass (* (/ (+ ?m0 ?m1) 3) 0.350))))
   (assert (element (formula ХлоридБария) (mass (* (/ (+ ?m0 ?m1) 3) 0.350))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.350))))
   (assert (appendmessagehalt (str-cat "Ba(OH)2 (" ?m0 ") + Cl2 (" ?m1 ") -(0.350)> Ba(ClO)2 (" (* (/ (+ ?m0 ?m1) 3) 0.350) ") + BaCl2 (" (* (/ (+ ?m0 ?m1) 3) 0.350) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.350) ")")))
)


(defrule ХлоридБария_ДигидрогенаМонооксид_ГидроксидБария_Водород_Хлор
   (declare (salience 40))
   (element (formula ХлоридБария) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидБария) (mass (* (/ (+ ?m0 ?m1) 3) 0.486))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 3) 0.486))))
   (assert (element (formula Хлор) (mass (* (/ (+ ?m0 ?m1) 3) 0.486))))
   (assert (appendmessagehalt (str-cat "BaCl2 (" ?m0 ") + H2O (" ?m1 ") -(0.486)> Ba(OH)2 (" (* (/ (+ ?m0 ?m1) 3) 0.486) ") + H2 (" (* (/ (+ ?m0 ?m1) 3) 0.486) ") + Cl2 (" (* (/ (+ ?m0 ?m1) 3) 0.486) ")")))
)


(defrule ГидроксидБария_Хлор_ХлоридБария_ХлоратБария_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидБария) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ХлоридБария) (mass (* (/ (+ ?m0 ?m1) 3) 0.312))))
   (assert (element (formula ХлоратБария) (mass (* (/ (+ ?m0 ?m1) 3) 0.312))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.312))))
   (assert (appendmessagehalt (str-cat "Ba(OH)2 (" ?m0 ") + Cl2 (" ?m1 ") -(0.312)> BaCl2 (" (* (/ (+ ?m0 ?m1) 3) 0.312) ") + Ba(ClO3)2 (" (* (/ (+ ?m0 ?m1) 3) 0.312) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.312) ")")))
)


(defrule ПерхлоратНатрия_ХлоридКалия_ПерхлоратКалия_ХлоридНатрия
   (declare (salience 40))
   (element (formula ПерхлоратНатрия) (mass ?m0))
   (element (formula ХлоридКалия) (mass ?m1))
   =>
   (assert (element (formula ПерхлоратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.676))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.676))))
   (assert (appendmessagehalt (str-cat "NaClO4 (" ?m0 ") + KCl (" ?m1 ") -(0.676)> KClO4 (" (* (/ (+ ?m0 ?m1) 2) 0.676) ") + NaCl (" (* (/ (+ ?m0 ?m1) 2) 0.676) ")")))
)


(defrule ХлоратКалия_Электролиз_ПерхлоратКалия_ХлоридКалия
   (declare (salience 40))
   (element (formula ХлоратКалия) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   =>
   (assert (element (formula ПерхлоратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.812))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.812))))
   (assert (appendmessagehalt (str-cat "KClO3 (" ?m0 ") + e (" ?m1 ") -(0.812)> KClO4 (" (* (/ (+ ?m0 ?m1) 2) 0.812) ") + KCl (" (* (/ (+ ?m0 ?m1) 2) 0.812) ")")))
)


(defrule ХлоратКалия_Тепло_ПерхлоратКалия_ХлоридКалия
   (declare (salience 40))
   (element (formula ХлоратКалия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ПерхлоратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.334))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.334))))
   (assert (appendmessagehalt (str-cat "KClO3 (" ?m0 ") + t (" ?m1 ") -(0.334)> KClO4 (" (* (/ (+ ?m0 ?m1) 2) 0.334) ") + KCl (" (* (/ (+ ?m0 ?m1) 2) 0.334) ")")))
)


(defrule ПерманганатКалия_СернаяКислота_ОксидМарганца7_СульфатКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ПерманганатКалия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula ОксидМарганца7) (mass (* (/ (+ ?m0 ?m1) 3) 0.389))))
   (assert (element (formula СульфатКалия) (mass (* (/ (+ ?m0 ?m1) 3) 0.389))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.389))))
   (assert (appendmessagehalt (str-cat "KMnO4 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.389)> Mn2O7 (" (* (/ (+ ?m0 ?m1) 3) 0.389) ") + K2SO4 (" (* (/ (+ ?m0 ?m1) 3) 0.389) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.389) ")")))
)


(defrule ОксидМарганца7_ОксидМарганца4_Кислород_Озон_Тепло
   (declare (salience 40))
   (element (formula ОксидМарганца7) (mass ?m0))
   =>
   (assert (element (formula ОксидМарганца4) (mass (* (/ ?m0 4) 0.869))))
   (assert (element (formula Кислород) (mass (* (/ ?m0 4) 0.869))))
   (assert (element (formula Озон) (mass (* (/ ?m0 4) 0.869))))
   (assert (element (formula Тепло) (mass (* (/ ?m0 4) 0.869))))
   (assert (appendmessagehalt (str-cat "Mn2O7 (" ?m0 ") -(0.869)> MnO2 (" (* (/ ?m0 4) 0.869) ") + O2 (" (* (/ ?m0 4) 0.869) ") + O3 (" (* (/ ?m0 4) 0.869) ") + t (" (* (/ ?m0 4) 0.869) ")")))
)


(defrule ОксидМарганца7_ДигидрогенаМонооксид_МарганцоваяКислота
   (declare (salience 40))
   (element (formula ОксидМарганца7) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula МарганцоваяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.686))))
   (assert (appendmessagehalt (str-cat "Mn2O7 (" ?m0 ") + H2O (" ?m1 ") -(0.686)> HMnO4 (" (* (/ (+ ?m0 ?m1) 1) 0.686) ")")))
)


(defrule ХлоридНатрия_СернаяКислота_СульфатНатрия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридНатрия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula СульфатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.829))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.829))))
   (assert (appendmessagehalt (str-cat "NaCl (" ?m0 ") + H2SO4 (" ?m1 ") -(0.829)> Na2SO4 (" (* (/ (+ ?m0 ?m1) 2) 0.829) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.829) ")")))
)


(defrule ОксидКальция_ДигидрогенаМонооксид_ГидроксидКальция
   (declare (salience 40))
   (element (formula ОксидКальция) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидКальция) (mass (* (/ (+ ?m0 ?m1) 1) 0.733))))
   (assert (appendmessagehalt (str-cat "CaO (" ?m0 ") + H2O (" ?m1 ") -(0.733)> Ca(OH)2 (" (* (/ (+ ?m0 ?m1) 1) 0.733) ")")))
)


(defrule ГидроксидКальция_УглекислыйГаз_КарбонатКальция_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидКальция) (mass ?m0))
   (element (formula УглекислыйГаз) (mass ?m1))
   =>
   (assert (element (formula КарбонатКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.773))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.773))))
   (assert (appendmessagehalt (str-cat "Ca(OH)2 (" ?m0 ") + CO2 (" ?m1 ") -(0.773)> CaCO3 (" (* (/ (+ ?m0 ?m1) 2) 0.773) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.773) ")")))
)


(defrule Кремний_ГидроксидНатрия_ОртосиликатНатрия_Водород
   (declare (salience 40))
   (element (formula Кремний) (mass ?m0))
   (element (formula ГидроксидНатрия) (mass ?m1))
   =>
   (assert (element (formula ОртосиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.806))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.806))))
   (assert (appendmessagehalt (str-cat "Si (" ?m0 ") + NaOH (" ?m1 ") -(0.806)> Na4SiO4 (" (* (/ (+ ?m0 ?m1) 2) 0.806) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.806) ")")))
)


(defrule ОксидКремния_ГидроксидНатрия_ОртосиликатНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидКремния) (mass ?m0))
   (element (formula ГидроксидНатрия) (mass ?m1))
   =>
   (assert (element (formula ОртосиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.897))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.897))))
   (assert (appendmessagehalt (str-cat "SiO2 (" ?m0 ") + NaOH (" ?m1 ") -(0.897)> Na4SiO4 (" (* (/ (+ ?m0 ?m1) 2) 0.897) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.897) ")")))
)


(defrule ОксидКремния_КарбонатНатрия_ОртосиликатНатрия_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидКремния) (mass ?m0))
   (element (formula КарбонатНатрия) (mass ?m1))
   =>
   (assert (element (formula ОртосиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.653))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.653))))
   (assert (appendmessagehalt (str-cat "SiO2 (" ?m0 ") + Na2CO3 (" ?m1 ") -(0.653)> Na4SiO4 (" (* (/ (+ ?m0 ?m1) 2) 0.653) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.653) ")")))
)


(defrule ОксидФосфора_ОксидФосфора5
   (declare (salience 40))
   (element (formula ОксидФосфора) (mass ?m0))
   =>
   (assert (element (formula ОксидФосфора5) (mass (* (/ ?m0 1) 0.743))))
   (assert (appendmessagehalt (str-cat "P4O10 (" ?m0 ") -(0.743)> P2O5 (" (* (/ ?m0 1) 0.743) ")")))
)


(defrule ОксидФосфора5_ОксидФосфора
   (declare (salience 40))
   (element (formula ОксидФосфора5) (mass ?m0))
   =>
   (assert (element (formula ОксидФосфора) (mass (* (/ ?m0 1) 0.825))))
   (assert (appendmessagehalt (str-cat "P2O5 (" ?m0 ") -(0.825)> P4O10 (" (* (/ ?m0 1) 0.825) ")")))
)


(defrule ОксидФосфора5_ДигидрогенаМонооксид_МетафосфорнаяКислота
   (declare (salience 40))
   (element (formula ОксидФосфора5) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula МетафосфорнаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.357))))
   (assert (appendmessagehalt (str-cat "P2O5 (" ?m0 ") + H2O (" ?m1 ") -(0.357)> HPO3 (" (* (/ (+ ?m0 ?m1) 1) 0.357) ")")))
)


(defrule СолянаяКислота_ГидроксидКалия_ХлоридКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СолянаяКислота) (mass ?m0))
   (element (formula ГидроксидКалия) (mass ?m1))
   =>
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.886))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.886))))
   (assert (appendmessagehalt (str-cat "HCl (" ?m0 ") + KOH (" ?m1 ") -(0.886)> KCl (" (* (/ (+ ?m0 ?m1) 2) 0.886) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.886) ")")))
)


(defrule ОксидХрома_КарбонатНатрия_Кислород_Тепло_ДихроматНатрия
   (declare (salience 40))
   (element (formula ОксидХрома) (mass ?m0))
   (element (formula КарбонатНатрия) (mass ?m1))
   (element (formula Кислород) (mass ?m2))
   (element (formula Тепло) (mass ?m3))
   =>
   (assert (element (formula ДихроматНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 1) 0.507))))
   (assert (appendmessagehalt (str-cat "Cr2O3 (" ?m0 ") + Na2CO3 (" ?m1 ") + O2 (" ?m2 ") + t (" ?m3 ") -(0.507)> Na2Cr2O7 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 1) 0.507) ")")))
)


(defrule Ртуть_Кислород_Тепло_ОксидРтути
   (declare (salience 40))
   (element (formula Ртуть) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидРтути) (mass (* (/ (+ ?m0 ?m1 ?m2) 1) 0.694))))
   (assert (appendmessagehalt (str-cat "Hg (" ?m0 ") + O2 (" ?m1 ") + t (" ?m2 ") -(0.694)> HgO (" (* (/ (+ ?m0 ?m1 ?m2) 1) 0.694) ")")))
)


(defrule СульфидРтути_ГидроксидНатрия_ОксидРтути_СульфидНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СульфидРтути) (mass ?m0))
   (element (formula ГидроксидНатрия) (mass ?m1))
   =>
   (assert (element (formula ОксидРтути) (mass (* (/ (+ ?m0 ?m1) 3) 0.858))))
   (assert (element (formula СульфидНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.858))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.858))))
   (assert (appendmessagehalt (str-cat "HgS (" ?m0 ") + NaOH (" ?m1 ") -(0.858)> HgO (" (* (/ (+ ?m0 ?m1) 3) 0.858) ") + Na2S (" (* (/ (+ ?m0 ?m1) 3) 0.858) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.858) ")")))
)


(defrule СульфидРтути_Кислород_Тепло_Ртуть_ДиоксидСеры
   (declare (salience 40))
   (element (formula СульфидРтути) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Ртуть) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.881))))
   (assert (element (formula ДиоксидСеры) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.881))))
   (assert (appendmessagehalt (str-cat "HgS (" ?m0 ") + O2 (" ?m1 ") + t (" ?m2 ") -(0.881)> Hg (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.881) ") + SO2 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.881) ")")))
)


(defrule СульфидРтути_Железо_Тепло_Ртуть_ОксидЖелеза3
   (declare (salience 40))
   (element (formula СульфидРтути) (mass ?m0))
   (element (formula Железо) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Ртуть) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.923))))
   (assert (element (formula ОксидЖелеза3) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.923))))
   (assert (appendmessagehalt (str-cat "HgS (" ?m0 ") + Fe (" ?m1 ") + t (" ?m2 ") -(0.923)> Hg (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.923) ") + Fe2O3 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.923) ")")))
)


(defrule Хлор_ГидроксидКалия_ХлоратКалия_ХлоридКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Хлор) (mass ?m0))
   (element (formula ГидроксидКалия) (mass ?m1))
   =>
   (assert (element (formula ХлоратКалия) (mass (* (/ (+ ?m0 ?m1) 3) 0.695))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 3) 0.695))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.695))))
   (assert (appendmessagehalt (str-cat "Cl2 (" ?m0 ") + KOH (" ?m1 ") -(0.695)> KClO3 (" (* (/ (+ ?m0 ?m1) 3) 0.695) ") + KCl (" (* (/ (+ ?m0 ?m1) 3) 0.695) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.695) ")")))
)


(defrule ХлоратНатрия_ХлорноватаяКислота_ХлоратНатрия_ДигидрогенаМонооксид_УглекислыйГаз
   (declare (salience 40))
   (element (formula ХлоратНатрия) (mass ?m0))
   (element (formula ХлорноватаяКислота) (mass ?m1))
   =>
   (assert (element (formula ХлоратНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.492))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.492))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 3) 0.492))))
   (assert (appendmessagehalt (str-cat "Na2ClO3 (" ?m0 ") + HClO3 (" ?m1 ") -(0.492)> NaClO3 (" (* (/ (+ ?m0 ?m1) 3) 0.492) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.492) ") + CO2 (" (* (/ (+ ?m0 ?m1) 3) 0.492) ")")))
)


(defrule ГидроксидНатрия_Хлор_ХлоратНатрия_ХлоридНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидНатрия) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ХлоратНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.325))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.325))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.325))))
   (assert (appendmessagehalt (str-cat "NaOH (" ?m0 ") + Cl2 (" ?m1 ") -(0.325)> NaClO3 (" (* (/ (+ ?m0 ?m1) 3) 0.325) ") + NaCl (" (* (/ (+ ?m0 ?m1) 3) 0.325) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.325) ")")))
)


(defrule ХлоридНатрия_ДигидрогенаМонооксид_Электролиз_ХлоратНатрия_ХлоридНатрия_Водород
   (declare (salience 40))
   (element (formula ХлоридНатрия) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   (element (formula Электролиз) (mass ?m2))
   =>
   (assert (element (formula ХлоратНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.883))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.883))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.883))))
   (assert (appendmessagehalt (str-cat "NaCl (" ?m0 ") + H2O (" ?m1 ") + e (" ?m2 ") -(0.883)> NaClO3 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.883) ") + NaCl (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.883) ") + H2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.883) ")")))
)


(defrule Барий_ДигидрогенаМонооксид_ГидроксидБария_Водород
   (declare (salience 40))
   (element (formula Барий) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.906))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.906))))
   (assert (appendmessagehalt (str-cat "Ba (" ?m0 ") + H2O (" ?m1 ") -(0.906)> Ba(OH)2 (" (* (/ (+ ?m0 ?m1) 2) 0.906) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.906) ")")))
)


(defrule ОксидБария_ДигидрогенаМонооксид_ГидроксидБария
   (declare (salience 40))
   (element (formula ОксидБария) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидБария) (mass (* (/ (+ ?m0 ?m1) 1) 0.463))))
   (assert (appendmessagehalt (str-cat "BaO (" ?m0 ") + H2O (" ?m1 ") -(0.463)> Ba(OH)2 (" (* (/ (+ ?m0 ?m1) 1) 0.463) ")")))
)


(defrule СульфидБария_ДигидрогенаМонооксид_ГидроксидБария_Сероводород
   (declare (salience 40))
   (element (formula СульфидБария) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.907))))
   (assert (element (formula Сероводород) (mass (* (/ (+ ?m0 ?m1) 2) 0.907))))
   (assert (appendmessagehalt (str-cat "BaS (" ?m0 ") + H2O (" ?m1 ") -(0.907)> Ba(OH)2 (" (* (/ (+ ?m0 ?m1) 2) 0.907) ") + H2S (" (* (/ (+ ?m0 ?m1) 2) 0.907) ")")))
)


(defrule ХлоратНатрия_Тепло_ПерхлоратНатрия_ХлоридНатрия
   (declare (salience 40))
   (element (formula ХлоратНатрия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ПерхлоратНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.320))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.320))))
   (assert (appendmessagehalt (str-cat "NaClO3 (" ?m0 ") + t (" ?m1 ") -(0.320)> NaClO4 (" (* (/ (+ ?m0 ?m1) 2) 0.320) ") + NaCl (" (* (/ (+ ?m0 ?m1) 2) 0.320) ")")))
)


(defrule ОксидМарганца4_Хлор_ГидроксидКалия_ПерманганатКалия_ХлоридКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМарганца4) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   (element (formula ГидроксидКалия) (mass ?m2))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.509))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.509))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.509))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + Cl2 (" ?m1 ") + KOH (" ?m2 ") -(0.509)> KMnO4 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.509) ") + KCl (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.509) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.509) ")")))
)


(defrule ПерманганатКалия_Хлор_ПерманганатКалия_ХлоридКалия
   (declare (salience 40))
   (element (formula ПерманганатКалия) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.816))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.816))))
   (assert (appendmessagehalt (str-cat "K2MnO4 (" ?m0 ") + Cl2 (" ?m1 ") -(0.816)> KMnO4 (" (* (/ (+ ?m0 ?m1) 2) 0.816) ") + KCl (" (* (/ (+ ?m0 ?m1) 2) 0.816) ")")))
)


(defrule ПерманганатКалия_ДигидрогенаМонооксид_ПерманганатКалия_ОксидМарганца4_ГидроксидКалия_Водород
   (declare (salience 40))
   (element (formula ПерманганатКалия) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1) 4) 0.762))))
   (assert (element (formula ОксидМарганца4) (mass (* (/ (+ ?m0 ?m1) 4) 0.762))))
   (assert (element (formula ГидроксидКалия) (mass (* (/ (+ ?m0 ?m1) 4) 0.762))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 4) 0.762))))
   (assert (appendmessagehalt (str-cat "K2MnO4 (" ?m0 ") + H2O (" ?m1 ") -(0.762)> KMnO4 (" (* (/ (+ ?m0 ?m1) 4) 0.762) ") + MnO2 (" (* (/ (+ ?m0 ?m1) 4) 0.762) ") + KOH (" (* (/ (+ ?m0 ?m1) 4) 0.762) ") + H2 (" (* (/ (+ ?m0 ?m1) 4) 0.762) ")")))
)


(defrule КарбонатКальция_Тепло_ОксидКальция_УглекислыйГаз
   (declare (salience 40))
   (element (formula КарбонатКальция) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.626))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.626))))
   (assert (appendmessagehalt (str-cat "CaCO3 (" ?m0 ") + t (" ?m1 ") -(0.626)> CaO (" (* (/ (+ ?m0 ?m1) 2) 0.626) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.626) ")")))
)


(defrule Кальций_Кислород_ОксидКальция
   (declare (salience 40))
   (element (formula Кальций) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидКальция) (mass (* (/ (+ ?m0 ?m1) 1) 0.353))))
   (assert (appendmessagehalt (str-cat "Ca (" ?m0 ") + O2 (" ?m1 ") -(0.353)> CaO (" (* (/ (+ ?m0 ?m1) 1) 0.353) ")")))
)


(defrule НитратКальция_Тепло_ОксидКальция_ОксидАзота4_Кислород
   (declare (salience 40))
   (element (formula НитратКальция) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидКальция) (mass (* (/ (+ ?m0 ?m1) 3) 0.537))))
   (assert (element (formula ОксидАзота4) (mass (* (/ (+ ?m0 ?m1) 3) 0.537))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 3) 0.537))))
   (assert (appendmessagehalt (str-cat "Ca(NO3)2 (" ?m0 ") + t (" ?m1 ") -(0.537)> CaO (" (* (/ (+ ?m0 ?m1) 3) 0.537) ") + NO2 (" (* (/ (+ ?m0 ?m1) 3) 0.537) ") + O2 (" (* (/ (+ ?m0 ?m1) 3) 0.537) ")")))
)


(defrule ОксидКремния_Марганец_Тепло_ОксидМарганца2_Кремний
   (declare (salience 40))
   (element (formula ОксидКремния) (mass ?m0))
   (element (formula Марганец) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидМарганца2) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.929))))
   (assert (element (formula Кремний) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.929))))
   (assert (appendmessagehalt (str-cat "SiO2 (" ?m0 ") + Mn (" ?m1 ") + t (" ?m2 ") -(0.929)> MnO (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.929) ") + Si (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.929) ")")))
)


(defrule ХлоридРтути_Сероводород_Кордероит_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридРтути) (mass ?m0))
   (element (formula Сероводород) (mass ?m1))
   =>
   (assert (element (formula Кордероит) (mass (* (/ (+ ?m0 ?m1) 2) 0.894))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.894))))
   (assert (appendmessagehalt (str-cat "HgCl2 (" ?m0 ") + H2S (" ?m1 ") -(0.894)> Hg3S2Cl2 (" (* (/ (+ ?m0 ?m1) 2) 0.894) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.894) ")")))
)


(defrule Кордероит_Сероводород_СульфидРтути_СолянаяКислота
   (declare (salience 40))
   (element (formula Кордероит) (mass ?m0))
   (element (formula Сероводород) (mass ?m1))
   =>
   (assert (element (formula СульфидРтути) (mass (* (/ (+ ?m0 ?m1) 2) 0.697))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.697))))
   (assert (appendmessagehalt (str-cat "Hg3S2Cl2 (" ?m0 ") + H2S (" ?m1 ") -(0.697)> HgS (" (* (/ (+ ?m0 ?m1) 2) 0.697) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.697) ")")))
)


(defrule СульфатБария_Углерод_СульфидБария_УгарныйГаз
   (declare (salience 40))
   (element (formula СульфатБария) (mass ?m0))
   (element (formula Углерод) (mass ?m1))
   =>
   (assert (element (formula СульфидБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.802))))
   (assert (element (formula УгарныйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.802))))
   (assert (appendmessagehalt (str-cat "BaSO4 (" ?m0 ") + C (" ?m1 ") -(0.802)> BaS (" (* (/ (+ ?m0 ?m1) 2) 0.802) ") + CO (" (* (/ (+ ?m0 ?m1) 2) 0.802) ")")))
)


(defrule ГидроксидБария_Сероводород_СульфидБария_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидБария) (mass ?m0))
   (element (formula Сероводород) (mass ?m1))
   =>
   (assert (element (formula СульфидБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.319))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.319))))
   (assert (appendmessagehalt (str-cat "Ba(OH)2 (" ?m0 ") + H2S (" ?m1 ") -(0.319)> BaS (" (* (/ (+ ?m0 ?m1) 2) 0.319) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.319) ")")))
)


(defrule ОксидМарганца4_ГидроксидКалия_НитратКалия_Тепло_ПерманганатКалия_НитритКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМарганца4) (mass ?m0))
   (element (formula ГидроксидКалия) (mass ?m1))
   (element (formula НитратКалия) (mass ?m2))
   (element (formula Тепло) (mass ?m3))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.777))))
   (assert (element (formula НитритКалия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.777))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.777))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + KOH (" ?m1 ") + KNO3 (" ?m2 ") + t (" ?m3 ") -(0.777)> K2MnO4 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.777) ") + KNO2 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.777) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.777) ")")))
)


(defrule ОксидМарганца4_КарбонатКалия_ХлоратКалия_Тепло_ПерманганатКалия_ХлоридКалия_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидМарганца4) (mass ?m0))
   (element (formula КарбонатКалия) (mass ?m1))
   (element (formula ХлоратКалия) (mass ?m2))
   (element (formula Тепло) (mass ?m3))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.712))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.712))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.712))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + K2CO3 (" ?m1 ") + KClO3 (" ?m2 ") + t (" ?m3 ") -(0.712)> K2MnO4 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.712) ") + KCl (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.712) ") + CO2 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.712) ")")))
)


(defrule ОксидМарганца4_ГидроксидКалия_Кислород_Тепло_ПерманганатКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМарганца4) (mass ?m0))
   (element (formula ГидроксидКалия) (mass ?m1))
   (element (formula Кислород) (mass ?m2))
   (element (formula Тепло) (mass ?m3))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.507))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.507))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + KOH (" ?m1 ") + O2 (" ?m2 ") + t (" ?m3 ") -(0.507)> K2MnO4 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.507) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.507) ")")))
)


(defrule ПерманганатКалия_Тепло_ПерманганатКалия_ОксидМарганца4_Кислород
   (declare (salience 40))
   (element (formula ПерманганатКалия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1) 3) 0.399))))
   (assert (element (formula ОксидМарганца4) (mass (* (/ (+ ?m0 ?m1) 3) 0.399))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 3) 0.399))))
   (assert (appendmessagehalt (str-cat "KMnO4 (" ?m0 ") + t (" ?m1 ") -(0.399)> K2MnO4 (" (* (/ (+ ?m0 ?m1) 3) 0.399) ") + MnO2 (" (* (/ (+ ?m0 ?m1) 3) 0.399) ") + O2 (" (* (/ (+ ?m0 ?m1) 3) 0.399) ")")))
)


(defrule ОксидМарганца4_ПероксидКалия_Тепло_ПерманганатКалия
   (declare (salience 40))
   (element (formula ОксидМарганца4) (mass ?m0))
   (element (formula ПероксидКалия) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 1) 0.404))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + K2O2 (" ?m1 ") + t (" ?m2 ") -(0.404)> K2MnO4 (" (* (/ (+ ?m0 ?m1 ?m2) 1) 0.404) ")")))
)


(defrule КарбонатКальция_АзотнаяКислота_НитратКальция_УглекислыйГаз_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula КарбонатКальция) (mass ?m0))
   (element (formula АзотнаяКислота) (mass ?m1))
   =>
   (assert (element (formula НитратКальция) (mass (* (/ (+ ?m0 ?m1) 3) 0.465))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 3) 0.465))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.465))))
   (assert (appendmessagehalt (str-cat "CaCO3 (" ?m0 ") + HNO3 (" ?m1 ") -(0.465)> Ca(NO3)2 (" (* (/ (+ ?m0 ?m1) 3) 0.465) ") + CO2 (" (* (/ (+ ?m0 ?m1) 3) 0.465) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.465) ")")))
)


(defrule НитратКальция_Тепло_ОксидКальция_ОксидАзота4_Кислород
   (declare (salience 40))
   (element (formula НитратКальция) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидКальция) (mass (* (/ (+ ?m0 ?m1) 3) 0.704))))
   (assert (element (formula ОксидАзота4) (mass (* (/ (+ ?m0 ?m1) 3) 0.704))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 3) 0.704))))
   (assert (appendmessagehalt (str-cat "Ca(NO3)2 (" ?m0 ") + t (" ?m1 ") -(0.704)> CaO (" (* (/ (+ ?m0 ?m1) 3) 0.704) ") + NO2 (" (* (/ (+ ?m0 ?m1) 3) 0.704) ") + O2 (" (* (/ (+ ?m0 ?m1) 3) 0.704) ")")))
)


(defrule Кальций_АзотнаяКислота_НитратКальция_ОксидАзота1_ОксидАзота2_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Кальций) (mass ?m0))
   (element (formula АзотнаяКислота) (mass ?m1))
   =>
   (assert (element (formula НитратКальция) (mass (* (/ (+ ?m0 ?m1) 4) 0.506))))
   (assert (element (formula ОксидАзота1) (mass (* (/ (+ ?m0 ?m1) 4) 0.506))))
   (assert (element (formula ОксидАзота2) (mass (* (/ (+ ?m0 ?m1) 4) 0.506))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 4) 0.506))))
   (assert (appendmessagehalt (str-cat "Ca (" ?m0 ") + HNO3 (" ?m1 ") -(0.506)> Ca(NO3)2 (" (* (/ (+ ?m0 ?m1) 4) 0.506) ") + N2O (" (* (/ (+ ?m0 ?m1) 4) 0.506) ") + NO (" (* (/ (+ ?m0 ?m1) 4) 0.506) ") + H2O (" (* (/ (+ ?m0 ?m1) 4) 0.506) ")")))
)


(defrule ОксидКальция_АзотнаяКислота_НитратКальция_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидКальция) (mass ?m0))
   (element (formula АзотнаяКислота) (mass ?m1))
   =>
   (assert (element (formula НитратКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.390))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.390))))
   (assert (appendmessagehalt (str-cat "CaO (" ?m0 ") + HNO3 (" ?m1 ") -(0.390)> Ca(NO3)2 (" (* (/ (+ ?m0 ?m1) 2) 0.390) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.390) ")")))
)


(defrule ГидроксидКальция_ОксидАзота4_НитратКальция_НитритКальция_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидКальция) (mass ?m0))
   (element (formula ОксидАзота4) (mass ?m1))
   =>
   (assert (element (formula НитратКальция) (mass (* (/ (+ ?m0 ?m1) 3) 0.873))))
   (assert (element (formula НитритКальция) (mass (* (/ (+ ?m0 ?m1) 3) 0.873))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.873))))
   (assert (appendmessagehalt (str-cat "Ca(OH)2 (" ?m0 ") + NO2 (" ?m1 ") -(0.873)> Ca(NO3)2 (" (* (/ (+ ?m0 ?m1) 3) 0.873) ") + Ca(NO2)2 (" (* (/ (+ ?m0 ?m1) 3) 0.873) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.873) ")")))
)


(defrule СульфидКальция_АзотнаяКислота_НитратКальция_Сера_ОксидАзота4_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СульфидКальция) (mass ?m0))
   (element (formula АзотнаяКислота) (mass ?m1))
   =>
   (assert (element (formula НитратКальция) (mass (* (/ (+ ?m0 ?m1) 4) 0.928))))
   (assert (element (formula Сера) (mass (* (/ (+ ?m0 ?m1) 4) 0.928))))
   (assert (element (formula ОксидАзота4) (mass (* (/ (+ ?m0 ?m1) 4) 0.928))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 4) 0.928))))
   (assert (appendmessagehalt (str-cat "CaS (" ?m0 ") + HNO3 (" ?m1 ") -(0.928)> Ca(NO3)2 (" (* (/ (+ ?m0 ?m1) 4) 0.928) ") + S (" (* (/ (+ ?m0 ?m1) 4) 0.928) ") + NO2 (" (* (/ (+ ?m0 ?m1) 4) 0.928) ") + H2O (" (* (/ (+ ?m0 ?m1) 4) 0.928) ")")))
)


(defrule ОксидМарганца4_Тепло_ОксидМарганца3
   (declare (salience 40))
   (element (formula ОксидМарганца4) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидМарганца3) (mass (* (/ (+ ?m0 ?m1) 1) 0.875))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + t (" ?m1 ") -(0.875)> Mn2O3 (" (* (/ (+ ?m0 ?m1) 1) 0.875) ")")))
)


(defrule ОксидМарганца3_Алюминий_Тепло_Марганец_ОксидАлюминия_Тепло
   (declare (salience 40))
   (element (formula ОксидМарганца3) (mass ?m0))
   (element (formula Алюминий) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Марганец) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.442))))
   (assert (element (formula ОксидАлюминия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.442))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.442))))
   (assert (appendmessagehalt (str-cat "Mn2O3 (" ?m0 ") + Al (" ?m1 ") + t (" ?m2 ") -(0.442)> Mn (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.442) ") + Al2O3 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.442) ") + t (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.442) ")")))
)


(defrule СульфидРтути_ХлоридРтути_Тепло_Кордероит
   (declare (salience 40))
   (element (formula СульфидРтути) (mass ?m0))
   (element (formula ХлоридРтути) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Кордероит) (mass (* (/ (+ ?m0 ?m1 ?m2) 1) 0.555))))
   (assert (appendmessagehalt (str-cat "HgS (" ?m0 ") + HgCl2 (" ?m1 ") + t (" ?m2 ") -(0.555)> Hg3S2Cl2 (" (* (/ (+ ?m0 ?m1 ?m2) 1) 0.555) ")")))
)


(defrule СульфидЖелеза_СолянаяКислота_Сероводород_ХлоридЖелеза
   (declare (salience 40))
   (element (formula СульфидЖелеза) (mass ?m0))
   (element (formula СолянаяКислота) (mass ?m1))
   =>
   (assert (element (formula Сероводород) (mass (* (/ (+ ?m0 ?m1) 2) 0.339))))
   (assert (element (formula ХлоридЖелеза) (mass (* (/ (+ ?m0 ?m1) 2) 0.339))))
   (assert (appendmessagehalt (str-cat "FeS (" ?m0 ") + HCl (" ?m1 ") -(0.339)> H2S (" (* (/ (+ ?m0 ?m1) 2) 0.339) ") + FeCl2 (" (* (/ (+ ?m0 ?m1) 2) 0.339) ")")))
)


(defrule СульфидАлюминия_ДигидрогенаМонооксид_Сероводород_ГидроксидАлюминия
   (declare (salience 40))
   (element (formula СульфидАлюминия) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula Сероводород) (mass (* (/ (+ ?m0 ?m1) 2) 0.930))))
   (assert (element (formula ГидроксидАлюминия) (mass (* (/ (+ ?m0 ?m1) 2) 0.930))))
   (assert (appendmessagehalt (str-cat "Al2S3 (" ?m0 ") + H2O (" ?m1 ") -(0.930)> H2S (" (* (/ (+ ?m0 ?m1) 2) 0.930) ") + Al(OH)3 (" (* (/ (+ ?m0 ?m1) 2) 0.930) ")")))
)


(defrule НитратКальция_КарбонатКалия_НитратКалия_КарбонатКальция
   (declare (salience 40))
   (element (formula НитратКальция) (mass ?m0))
   (element (formula КарбонатКалия) (mass ?m1))
   =>
   (assert (element (formula НитратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.619))))
   (assert (element (formula КарбонатКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.619))))
   (assert (appendmessagehalt (str-cat "Ca(NO3)2 (" ?m0 ") + K2CO3 (" ?m1 ") -(0.619)> KNO3 (" (* (/ (+ ?m0 ?m1) 2) 0.619) ") + CaCO3 (" (* (/ (+ ?m0 ?m1) 2) 0.619) ")")))
)


(defrule НитратКальция_СульфатКалия_НитратКалия_СульфатКальция
   (declare (salience 40))
   (element (formula НитратКальция) (mass ?m0))
   (element (formula СульфатКалия) (mass ?m1))
   =>
   (assert (element (formula НитратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.308))))
   (assert (element (formula СульфатКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.308))))
   (assert (appendmessagehalt (str-cat "Ca(NO3)2 (" ?m0 ") + K2SO4 (" ?m1 ") -(0.308)> KNO3 (" (* (/ (+ ?m0 ?m1) 2) 0.308) ") + CaSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.308) ")")))
)


(defrule Калий_Кислород_Холод_ПероксидКалия
   (declare (salience 40))
   (element (formula Калий) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Холод) (mass ?m2))
   =>
   (assert (element (formula ПероксидКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 1) 0.455))))
   (assert (appendmessagehalt (str-cat "K (" ?m0 ") + O2 (" ?m1 ") + not_t (" ?m2 ") -(0.455)> K2O2 (" (* (/ (+ ?m0 ?m1 ?m2) 1) 0.455) ")")))
)


(defrule ОксидКальция_Тепло_ПероксидКалия_Кислород
   (declare (salience 40))
   (element (formula ОксидКальция) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ПероксидКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.913))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 2) 0.913))))
   (assert (appendmessagehalt (str-cat "KO2 (" ?m0 ") + t (" ?m1 ") -(0.913)> K2O2 (" (* (/ (+ ?m0 ?m1) 2) 0.913) ") + O2 (" (* (/ (+ ?m0 ?m1) 2) 0.913) ")")))
)


(defrule ОксидАлюминия_Электролиз_Тепло_Криолит_Алюминий_Кислород_Криолит
   (declare (salience 40))
   (element (formula ОксидАлюминия) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   (element (formula Криолит) (mass ?m3))
   =>
   (assert (element (formula Алюминий) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.523))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.523))))
   (assert (element (formula Криолит) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.523))))
   (assert (appendmessagehalt (str-cat "Al2O3 (" ?m0 ") + e (" ?m1 ") + t (" ?m2 ") + Na3AlF6 (" ?m3 ") -(0.523)> Al (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.523) ") + O2 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.523) ") + Na3AlF6 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.523) ")")))
)


(defrule ХлоридАлюминия_Калий_Тепло_ХлоридКалия_Алюминий
   (declare (salience 40))
   (element (formula ХлоридАлюминия) (mass ?m0))
   (element (formula Калий) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.871))))
   (assert (element (formula Алюминий) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.871))))
   (assert (appendmessagehalt (str-cat "AlCl3 (" ?m0 ") + K (" ?m1 ") + t (" ?m2 ") -(0.871)> KCl (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.871) ") + Al (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.871) ")")))
)


(defrule Железо_Сера_СульфидЖелеза
   (declare (salience 40))
   (element (formula Железо) (mass ?m0))
   (element (formula Сера) (mass ?m1))
   =>
   (assert (element (formula СульфидЖелеза) (mass (* (/ (+ ?m0 ?m1) 1) 0.713))))
   (assert (appendmessagehalt (str-cat "Fe (" ?m0 ") + S (" ?m1 ") -(0.713)> FeS (" (* (/ (+ ?m0 ?m1) 1) 0.713) ")")))
)


(defrule СульфидЖелеза_Тепло_СульфидЖелеза
   (declare (salience 40))
   (element (formula СульфидЖелеза) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula СульфидЖелеза) (mass (* (/ (+ ?m0 ?m1) 1) 0.563))))
   (assert (appendmessagehalt (str-cat "FeS2 (" ?m0 ") + t (" ?m1 ") -(0.563)> FeS (" (* (/ (+ ?m0 ?m1) 1) 0.563) ")")))
)


(defrule ОксидЖелеза3_Водород_Сероводород_СульфидЖелеза_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидЖелеза3) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   (element (formula Сероводород) (mass ?m2))
   =>
   (assert (element (formula СульфидЖелеза) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.939))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.939))))
   (assert (appendmessagehalt (str-cat "Fe2O3 (" ?m0 ") + H2 (" ?m1 ") + H2S (" ?m2 ") -(0.939)> FeS (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.939) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.939) ")")))
)


(defrule Алюминий_Сера_Тепло_СульфидАлюминия
   (declare (salience 40))
   (element (formula Алюминий) (mass ?m0))
   (element (formula Сера) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula СульфидАлюминия) (mass (* (/ (+ ?m0 ?m1 ?m2) 1) 0.434))))
   (assert (appendmessagehalt (str-cat "Al (" ?m0 ") + S (" ?m1 ") + t (" ?m2 ") -(0.434)> Al2S3 (" (* (/ (+ ?m0 ?m1 ?m2) 1) 0.434) ")")))
)


(defrule Натрий_ГидроксидКалия_ГидроксидНатрия_Калий
   (declare (salience 40))
   (element (formula Натрий) (mass ?m0))
   (element (formula ГидроксидКалия) (mass ?m1))
   =>
   (assert (element (formula ГидроксидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.326))))
   (assert (element (formula Калий) (mass (* (/ (+ ?m0 ?m1) 2) 0.326))))
   (assert (appendmessagehalt (str-cat "Na (" ?m0 ") + KOH (" ?m1 ") -(0.326)> NaOH (" (* (/ (+ ?m0 ?m1) 2) 0.326) ") + K (" (* (/ (+ ?m0 ?m1) 2) 0.326) ")")))
)


(defrule ОксидМеди_Алюминий_Тепло_ОксидАлюминия_Медь
   (declare (salience 40))
   (element (formula ОксидМеди) (mass ?m0))
   (element (formula Алюминий) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидАлюминия) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.689))))
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.689))))
   (assert (appendmessagehalt (str-cat "Cu2O (" ?m0 ") + Al (" ?m1 ") + t (" ?m2 ") -(0.689)> Al2O3 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.689) ") + Cu (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.689) ")")))
)


(defrule ГидроксидАлюминия_Тепло_ОксидАлюминия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидАлюминия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидАлюминия) (mass (* (/ (+ ?m0 ?m1) 2) 0.587))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.587))))
   (assert (appendmessagehalt (str-cat "Al(OH)3 (" ?m0 ") + t (" ?m1 ") -(0.587)> Al2O3 (" (* (/ (+ ?m0 ?m1) 2) 0.587) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.587) ")")))
)


(defrule ОксидЖелеза3_Водород_Тепло_Железо_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидЖелеза3) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Железо) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.377))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.377))))
   (assert (appendmessagehalt (str-cat "Fe2O3 (" ?m0 ") + H2 (" ?m1 ") + t (" ?m2 ") -(0.377)> Fe (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.377) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.377) ")")))
)


(defrule ОксидЖелеза3_УгарныйГаз_Железо_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидЖелеза3) (mass ?m0))
   (element (formula УгарныйГаз) (mass ?m1))
   =>
   (assert (element (formula Железо) (mass (* (/ (+ ?m0 ?m1) 2) 0.942))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.942))))
   (assert (appendmessagehalt (str-cat "Fe2O3 (" ?m0 ") + CO (" ?m1 ") -(0.942)> Fe (" (* (/ (+ ?m0 ?m1) 2) 0.942) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.942) ")")))
)


(defrule ОксидЖелеза_УгарныйГаз_Железо_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидЖелеза) (mass ?m0))
   (element (formula УгарныйГаз) (mass ?m1))
   =>
   (assert (element (formula Железо) (mass (* (/ (+ ?m0 ?m1) 2) 0.760))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.760))))
   (assert (appendmessagehalt (str-cat "FeO (" ?m0 ") + CO (" ?m1 ") -(0.760)> Fe (" (* (/ (+ ?m0 ?m1) 2) 0.760) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.760) ")")))
)


(defrule ОксидЖелеза_УгарныйГаз_Железо_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидЖелеза) (mass ?m0))
   (element (formula УгарныйГаз) (mass ?m1))
   =>
   (assert (element (formula Железо) (mass (* (/ (+ ?m0 ?m1) 2) 0.842))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.842))))
   (assert (appendmessagehalt (str-cat "FeO (" ?m0 ") + CO (" ?m1 ") -(0.842)> Fe (" (* (/ (+ ?m0 ?m1) 2) 0.842) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.842) ")")))
)


(defrule ОксидЖелеза3_Алюминий_Железо_ОксидАлюминия
   (declare (salience 40))
   (element (formula ОксидЖелеза3) (mass ?m0))
   (element (formula Алюминий) (mass ?m1))
   =>
   (assert (element (formula Железо) (mass (* (/ (+ ?m0 ?m1) 2) 0.838))))
   (assert (element (formula ОксидАлюминия) (mass (* (/ (+ ?m0 ?m1) 2) 0.838))))
   (assert (appendmessagehalt (str-cat "Fe2O3 (" ?m0 ") + Al (" ?m1 ") -(0.838)> Fe (" (* (/ (+ ?m0 ?m1) 2) 0.838) ") + Al2O3 (" (* (/ (+ ?m0 ?m1) 2) 0.838) ")")))
)


(defrule Медь_Кислород_Тепло_ОксидМеди2_ОксидМеди
   (declare (salience 40))
   (element (formula Медь) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидМеди2) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.404))))
   (assert (element (formula ОксидМеди) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.404))))
   (assert (appendmessagehalt (str-cat "Cu (" ?m0 ") + O2 (" ?m1 ") + t (" ?m2 ") -(0.404)> CuO (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.404) ") + Cu2O (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.404) ")")))
)


(defrule Медь_ОксидАзота1_Тепло_ОксидМеди_Азот
   (declare (salience 40))
   (element (formula Медь) (mass ?m0))
   (element (formula ОксидАзота1) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидМеди) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.510))))
   (assert (element (formula Азот) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.510))))
   (assert (appendmessagehalt (str-cat "Cu (" ?m0 ") + N2O (" ?m1 ") + t (" ?m2 ") -(0.510)> Cu2O (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.510) ") + N2 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.510) ")")))
)


(defrule ОксидМеди2_Углерод_Медь_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидМеди2) (mass ?m0))
   (element (formula Углерод) (mass ?m1))
   =>
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1) 2) 0.488))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.488))))
   (assert (appendmessagehalt (str-cat "CuO (" ?m0 ") + C (" ?m1 ") -(0.488)> Cu (" (* (/ (+ ?m0 ?m1) 2) 0.488) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.488) ")")))
)


(defrule ОксидМеди2_Водород_Медь_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМеди2) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   =>
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1) 2) 0.393))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.393))))
   (assert (appendmessagehalt (str-cat "CuO (" ?m0 ") + H2 (" ?m1 ") -(0.393)> Cu (" (* (/ (+ ?m0 ?m1) 2) 0.393) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.393) ")")))
)


(defrule Малахит_Тепло_ОксидМеди2_УглекислыйГаз_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Малахит) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидМеди2) (mass (* (/ (+ ?m0 ?m1) 3) 0.871))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 3) 0.871))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.871))))
   (assert (appendmessagehalt (str-cat "(CuOH)2CO3 (" ?m0 ") + t (" ?m1 ") -(0.871)> CuO (" (* (/ (+ ?m0 ?m1) 3) 0.871) ") + CO2 (" (* (/ (+ ?m0 ?m1) 3) 0.871) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.871) ")")))
)


(defrule Малахит_УгарныйГаз_Тепло_УглекислыйГаз_Медь_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Малахит) (mass ?m0))
   (element (formula УгарныйГаз) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.718))))
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.718))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.718))))
   (assert (appendmessagehalt (str-cat "(CuOH)2CO3 (" ?m0 ") + CO (" ?m1 ") + t (" ?m2 ") -(0.718)> CO2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.718) ") + Cu (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.718) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.718) ")")))
)


(defrule ХлоридБария_Электролиз_Барий_Хлор
   (declare (salience 40))
   (element (formula ХлоридБария) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   =>
   (assert (element (formula Барий) (mass (* (/ (+ ?m0 ?m1) 2) 0.501))))
   (assert (element (formula Хлор) (mass (* (/ (+ ?m0 ?m1) 2) 0.501))))
   (assert (appendmessagehalt (str-cat "BaCl2 (" ?m0 ") + e (" ?m1 ") -(0.501)> Ba (" (* (/ (+ ?m0 ?m1) 2) 0.501) ") + Cl2 (" (* (/ (+ ?m0 ?m1) 2) 0.501) ")")))
)


(defrule СолянаяКислота_ОксидМарганца4_Хлор_ХлоридМарганца_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СолянаяКислота) (mass ?m0))
   (element (formula ОксидМарганца4) (mass ?m1))
   =>
   (assert (element (formula Хлор) (mass (* (/ (+ ?m0 ?m1) 3) 0.906))))
   (assert (element (formula ХлоридМарганца) (mass (* (/ (+ ?m0 ?m1) 3) 0.906))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.906))))
   (assert (appendmessagehalt (str-cat "HCl (" ?m0 ") + MnO2 (" ?m1 ") -(0.906)> Cl2 (" (* (/ (+ ?m0 ?m1) 3) 0.906) ") + MnCl2 (" (* (/ (+ ?m0 ?m1) 3) 0.906) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.906) ")")))
)


(defrule ХлоридНатрия_Электролиз_Натрий_Хлор
   (declare (salience 40))
   (element (formula ХлоридНатрия) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   =>
   (assert (element (formula Натрий) (mass (* (/ (+ ?m0 ?m1) 2) 0.817))))
   (assert (element (formula Хлор) (mass (* (/ (+ ?m0 ?m1) 2) 0.817))))
   (assert (appendmessagehalt (str-cat "NaCl (" ?m0 ") + e (" ?m1 ") -(0.817)> Na (" (* (/ (+ ?m0 ?m1) 2) 0.817) ") + Cl2 (" (* (/ (+ ?m0 ?m1) 2) 0.817) ")")))
)


(defrule ХлоридКалия_ДигидрогенаМонооксид_Электролиз_ГидроксидКалия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридКалия) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   (element (formula Электролиз) (mass ?m2))
   =>
   (assert (element (formula ГидроксидКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.397))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.397))))
   (assert (appendmessagehalt (str-cat "KCl (" ?m0 ") + H2O (" ?m1 ") + e (" ?m2 ") -(0.397)> KOH (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.397) ") + HCl (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.397) ")")))
)


(defrule Халькопирит_Кислород_Тепло_СульфидМеди_ОксидЖелеза
   (declare (salience 40))
   (element (formula Халькопирит) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula СульфидМеди) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.531))))
   (assert (element (formula ОксидЖелеза) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.531))))
   (assert (appendmessagehalt (str-cat "CuFeS2 (" ?m0 ") + O2 (" ?m1 ") + t (" ?m2 ") -(0.531)> Cu2S (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.531) ") + FeO (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.531) ")")))
)


(defrule СульфидМеди_ДигидрогенаМонооксид_Тепло_Медь_ДиоксидСеры_Водород
   (declare (salience 40))
   (element (formula СульфидМеди) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.890))))
   (assert (element (formula ДиоксидСеры) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.890))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.890))))
   (assert (appendmessagehalt (str-cat "Cu2S (" ?m0 ") + H2O (" ?m1 ") + t (" ?m2 ") -(0.890)> Cu (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.890) ") + SO2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.890) ") + H2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.890) ")")))
)


(defrule СульфидМеди_Тепло_Медь_Сера
   (declare (salience 40))
   (element (formula СульфидМеди) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1) 2) 0.620))))
   (assert (element (formula Сера) (mass (* (/ (+ ?m0 ?m1) 2) 0.620))))
   (assert (appendmessagehalt (str-cat "Cu2S (" ?m0 ") + t (" ?m1 ") -(0.620)> Cu (" (* (/ (+ ?m0 ?m1) 2) 0.620) ") + S (" (* (/ (+ ?m0 ?m1) 2) 0.620) ")")))
)


(defrule СульфидСвинца_СолянаяКислота_ХлоридСвинца_Сероводород
   (declare (salience 40))
   (element (formula СульфидСвинца) (mass ?m0))
   (element (formula СолянаяКислота) (mass ?m1))
   =>
   (assert (element (formula ХлоридСвинца) (mass (* (/ (+ ?m0 ?m1) 2) 0.371))))
   (assert (element (formula Сероводород) (mass (* (/ (+ ?m0 ?m1) 2) 0.371))))
   (assert (appendmessagehalt (str-cat "PbS (" ?m0 ") + HCl (" ?m1 ") -(0.371)> PbCl2 (" (* (/ (+ ?m0 ?m1) 2) 0.371) ") + H2S (" (* (/ (+ ?m0 ?m1) 2) 0.371) ")")))
)


(defrule СульфидСвинца_Водород_Тепло_Свинец_Сероводород
   (declare (salience 40))
   (element (formula СульфидСвинца) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Свинец) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.314))))
   (assert (element (formula Сероводород) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.314))))
   (assert (appendmessagehalt (str-cat "PbS (" ?m0 ") + H2 (" ?m1 ") + t (" ?m2 ") -(0.314)> Pb (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.314) ") + H2S (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.314) ")")))
)


(defrule СульфидСвинца_Озон_СульфатСвинца_Кислород
   (declare (salience 40))
   (element (formula СульфидСвинца) (mass ?m0))
   (element (formula Озон) (mass ?m1))
   =>
   (assert (element (formula СульфатСвинца) (mass (* (/ (+ ?m0 ?m1) 2) 0.557))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 2) 0.557))))
   (assert (appendmessagehalt (str-cat "PbS (" ?m0 ") + O3 (" ?m1 ") -(0.557)> PbSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.557) ") + O2 (" (* (/ (+ ?m0 ?m1) 2) 0.557) ")")))
)


(defrule ХлоридСвинца_ДигидрогенаМонооксид_ГидроксидХлоридСвинца_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридСвинца) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидХлоридСвинца) (mass (* (/ (+ ?m0 ?m1) 2) 0.609))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.609))))
   (assert (appendmessagehalt (str-cat "PbCl2 (" ?m0 ") + H2O (" ?m1 ") -(0.609)> Pb(OH)Cl (" (* (/ (+ ?m0 ?m1) 2) 0.609) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.609) ")")))
)


(defrule ХлоридСвинца_Водород_Тепло_Свинец_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридСвинца) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Свинец) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.885))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.885))))
   (assert (appendmessagehalt (str-cat "PbCl2 (" ?m0 ") + H2 (" ?m1 ") + t (" ?m2 ") -(0.885)> Pb (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.885) ") + HCl (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.885) ")")))
)