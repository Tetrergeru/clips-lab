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
   (assert (element (formula Электролиз) (mass (* (/ (+ ?m0 ?m1) 1) 0.9190238))))
   (assert (appendmessagehalt (str-cat "Электричество (" ?m0 ") + H2O (" ?m1 ") -(0.9190238)> e (" (* (/ (+ ?m0 ?m1) 1) 0.9190238) ")")))
)


(defrule Киноварь_СульфидРтути
   (declare (salience 40))
   (element (formula Киноварь) (mass ?m0))
   =>
   (assert (element (formula СульфидРтути) (mass (* (/ ?m0 1) 0.3082173))))
   (assert (appendmessagehalt (str-cat "Киноварь (" ?m0 ") -(0.3082173)> HgS (" (* (/ ?m0 1) 0.3082173) ")")))
)


(defrule Воздух_Кислород_Азот_УглекислыйГаз
   (declare (salience 40))
   (element (formula Воздух) (mass ?m0))
   =>
   (assert (element (formula Кислород) (mass (* (/ ?m0 3) 0.7831073))))
   (assert (element (formula Азот) (mass (* (/ ?m0 3) 0.7831073))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ ?m0 3) 0.7831073))))
   (assert (appendmessagehalt (str-cat "Воздух (" ?m0 ") -(0.7831073)> O2 (" (* (/ ?m0 3) 0.7831073) ") + N2 (" (* (/ ?m0 3) 0.7831073) ") + CO2 (" (* (/ ?m0 3) 0.7831073) ")")))
)


(defrule ЩавелеваяКислота_ЩавелеваяКислота
   (declare (salience 40))
   (element (formula ЩавелеваяКислота) (mass ?m0))
   =>
   (assert (element (formula ЩавелеваяКислота) (mass (* (/ ?m0 1) 0.4698831))))
   (assert (appendmessagehalt (str-cat "ЩавелеваяКислота (" ?m0 ") -(0.4698831)> H2C2O4 (" (* (/ ?m0 1) 0.4698831) ")")))
)


(defrule Песок_ОксидКремния
   (declare (salience 40))
   (element (formula Песок) (mass ?m0))
   =>
   (assert (element (formula ОксидКремния) (mass (* (/ ?m0 1) 0.8942624))))
   (assert (appendmessagehalt (str-cat "Песок (" ?m0 ") -(0.8942624)> SiO2 (" (* (/ ?m0 1) 0.8942624) ")")))
)


(defrule Известняк_КарбонатКальция
   (declare (salience 40))
   (element (formula Известняк) (mass ?m0))
   =>
   (assert (element (formula КарбонатКальция) (mass (* (/ ?m0 1) 0.8709831))))
   (assert (appendmessagehalt (str-cat "Известняк (" ?m0 ") -(0.8709831)> CaCO3 (" (* (/ ?m0 1) 0.8709831) ")")))
)


(defrule Вода_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Вода) (mass ?m0))
   =>
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ ?m0 1) 0.3590202))))
   (assert (appendmessagehalt (str-cat "Вода (" ?m0 ") -(0.3590202)> H2O (" (* (/ ?m0 1) 0.3590202) ")")))
)


(defrule Боксит_ГидроксидАлюминия_ОксидЖелеза3_ОксидЖелеза
   (declare (salience 40))
   (element (formula Боксит) (mass ?m0))
   =>
   (assert (element (formula ГидроксидАлюминия) (mass (* (/ ?m0 3) 0.8570454))))
   (assert (element (formula ОксидЖелеза3) (mass (* (/ ?m0 3) 0.8570454))))
   (assert (element (formula ОксидЖелеза) (mass (* (/ ?m0 3) 0.8570454))))
   (assert (appendmessagehalt (str-cat "Боксит (" ?m0 ") -(0.8570454)> Al(OH)3 (" (* (/ ?m0 3) 0.8570454) ") + Fe2O3 (" (* (/ ?m0 3) 0.8570454) ") + FeO (" (* (/ ?m0 3) 0.8570454) ")")))
)


(defrule Магнетит_ОксидЖелеза_ОксидЖелеза3
   (declare (salience 40))
   (element (formula Магнетит) (mass ?m0))
   =>
   (assert (element (formula ОксидЖелеза) (mass (* (/ ?m0 2) 0.9065762))))
   (assert (element (formula ОксидЖелеза3) (mass (* (/ ?m0 2) 0.9065762))))
   (assert (appendmessagehalt (str-cat "Магнетит (" ?m0 ") -(0.9065762)> FeO (" (* (/ ?m0 2) 0.9065762) ") + Fe2O3 (" (* (/ ?m0 2) 0.9065762) ")")))
)


(defrule Малахит_Малахит
   (declare (salience 40))
   (element (formula Малахит) (mass ?m0))
   =>
   (assert (element (formula Малахит) (mass (* (/ ?m0 1) 0.7494608))))
   (assert (appendmessagehalt (str-cat "Малахит (" ?m0 ") -(0.7494608)> (CuOH)2CO3 (" (* (/ ?m0 1) 0.7494608) ")")))
)


(defrule Соль_ХлоридНатрия
   (declare (salience 40))
   (element (formula Соль) (mass ?m0))
   =>
   (assert (element (formula ХлоридНатрия) (mass (* (/ ?m0 1) 0.8263629))))
   (assert (appendmessagehalt (str-cat "Соль (" ?m0 ") -(0.8263629)> NaCl (" (* (/ ?m0 1) 0.8263629) ")")))
)


(defrule Барит_СульфатБария
   (declare (salience 40))
   (element (formula Барит) (mass ?m0))
   =>
   (assert (element (formula СульфатБария) (mass (* (/ ?m0 1) 0.6140369))))
   (assert (appendmessagehalt (str-cat "Барит (" ?m0 ") -(0.6140369)> BaSO4 (" (* (/ ?m0 1) 0.6140369) ")")))
)


(defrule Пиролюзит_ОксидМарганца
   (declare (salience 40))
   (element (formula Пиролюзит) (mass ?m0))
   =>
   (assert (element (formula ОксидМарганца) (mass (* (/ ?m0 1) 0.6983861))))
   (assert (appendmessagehalt (str-cat "Пиролюзит (" ?m0 ") -(0.6983861)> MnO2 (" (* (/ ?m0 1) 0.6983861) ")")))
)


(defrule Фосфорит_ОксидФосфора
   (declare (salience 40))
   (element (formula Фосфорит) (mass ?m0))
   =>
   (assert (element (formula ОксидФосфора) (mass (* (/ ?m0 1) 0.7280934))))
   (assert (appendmessagehalt (str-cat "Фосфорит (" ?m0 ") -(0.7280934)> P4O10 (" (* (/ ?m0 1) 0.7280934) ")")))
)


(defrule Пирит_СульфидЖелеза
   (declare (salience 40))
   (element (formula Пирит) (mass ?m0))
   =>
   (assert (element (formula СульфидЖелеза) (mass (* (/ ?m0 1) 0.878032))))
   (assert (appendmessagehalt (str-cat "Пирит (" ?m0 ") -(0.878032)> FeS2 (" (* (/ ?m0 1) 0.878032) ")")))
)


(defrule МедныйКолчедан_Халькопирит
   (declare (salience 40))
   (element (formula МедныйКолчедан) (mass ?m0))
   =>
   (assert (element (formula Халькопирит) (mass (* (/ ?m0 1) 0.8869864))))
   (assert (appendmessagehalt (str-cat "МедныйКолчедан (" ?m0 ") -(0.8869864)> CuFeS2 (" (* (/ ?m0 1) 0.8869864) ")")))
)


(defrule Галенит_СульфидСвинца
   (declare (salience 40))
   (element (formula Галенит) (mass ?m0))
   =>
   (assert (element (formula СульфидСвинца) (mass (* (/ ?m0 1) 0.873366))))
   (assert (appendmessagehalt (str-cat "Галенит (" ?m0 ") -(0.873366)> PbS (" (* (/ ?m0 1) 0.873366) ")")))
)


(defrule Уголь_Углерод
   (declare (salience 40))
   (element (formula Уголь) (mass ?m0))
   =>
   (assert (element (formula Углерод) (mass (* (/ ?m0 1) 0.7846088))))
   (assert (appendmessagehalt (str-cat "Уголь (" ?m0 ") -(0.7846088)> C (" (* (/ ?m0 1) 0.7846088) ")")))
)


(defrule Котик_Тепло
   (declare (salience 40))
   (element (formula Котик) (mass ?m0))
   =>
   (assert (element (formula Тепло) (mass (* (/ ?m0 1) 0.6235484))))
   (assert (appendmessagehalt (str-cat "Котик (" ?m0 ") -(0.6235484)> t (" (* (/ ?m0 1) 0.6235484) ")")))
)


(defrule Кислород_Водород_ДигидрогенаМонооксид_Тепло
   (declare (salience 40))
   (element (formula Кислород) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   =>
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.7253122))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 2) 0.7253122))))
   (assert (appendmessagehalt (str-cat "O2 (" ?m0 ") + H2 (" ?m1 ") -(0.7253122)> H2O (" (* (/ (+ ?m0 ?m1) 2) 0.7253122) ") + t (" (* (/ (+ ?m0 ?m1) 2) 0.7253122) ")")))
)


(defrule Кислород_Тепло_Озон
   (declare (salience 40))
   (element (formula Кислород) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula Озон) (mass (* (/ (+ ?m0 ?m1) 1) 0.403714))))
   (assert (appendmessagehalt (str-cat "O2 (" ?m0 ") + t (" ?m1 ") -(0.403714)> O3 (" (* (/ (+ ?m0 ?m1) 1) 0.403714) ")")))
)


(defrule Кислород_Свет_Озон
   (declare (salience 40))
   (element (formula Кислород) (mass ?m0))
   (element (formula Свет) (mass ?m1))
   =>
   (assert (element (formula Озон) (mass (* (/ (+ ?m0 ?m1) 1) 0.5229448))))
   (assert (appendmessagehalt (str-cat "O2 (" ?m0 ") + hv (" ?m1 ") -(0.5229448)> O3 (" (* (/ (+ ?m0 ?m1) 1) 0.5229448) ")")))
)


(defrule Озон_Кислород_Тепло
   (declare (salience 40))
   (element (formula Озон) (mass ?m0))
   =>
   (assert (element (formula Кислород) (mass (* (/ ?m0 2) 0.7094164))))
   (assert (element (formula Тепло) (mass (* (/ ?m0 2) 0.7094164))))
   (assert (appendmessagehalt (str-cat "O3 (" ?m0 ") -(0.7094164)> O2 (" (* (/ ?m0 2) 0.7094164) ") + t (" (* (/ ?m0 2) 0.7094164) ")")))
)


(defrule ДигидрогенаМонооксид_Электролиз_Водород_Кислород
   (declare (salience 40))
   (element (formula ДигидрогенаМонооксид) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   =>
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.8391053))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 2) 0.8391053))))
   (assert (appendmessagehalt (str-cat "H2O (" ?m0 ") + e (" ?m1 ") -(0.8391053)> H2 (" (* (/ (+ ?m0 ?m1) 2) 0.8391053) ") + O2 (" (* (/ (+ ?m0 ?m1) 2) 0.8391053) ")")))
)


(defrule Сера_Кислород_МонооксидСеры_ДиоксидСеры_ТриоксидСеры
   (declare (salience 40))
   (element (formula Сера) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula МонооксидСеры) (mass (* (/ (+ ?m0 ?m1) 3) 0.5375981))))
   (assert (element (formula ДиоксидСеры) (mass (* (/ (+ ?m0 ?m1) 3) 0.5375981))))
   (assert (element (formula ТриоксидСеры) (mass (* (/ (+ ?m0 ?m1) 3) 0.5375981))))
   (assert (appendmessagehalt (str-cat "S (" ?m0 ") + O2 (" ?m1 ") -(0.5375981)> SO (" (* (/ (+ ?m0 ?m1) 3) 0.5375981) ") + SO2 (" (* (/ (+ ?m0 ?m1) 3) 0.5375981) ") + SO3 (" (* (/ (+ ?m0 ?m1) 3) 0.5375981) ")")))
)


(defrule Фтор_Кислород_ОксидФтора
   (declare (salience 40))
   (element (formula Фтор) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидФтора) (mass (* (/ (+ ?m0 ?m1) 1) 0.7799194))))
   (assert (appendmessagehalt (str-cat "F2 (" ?m0 ") + O2 (" ?m1 ") -(0.7799194)> F2O (" (* (/ (+ ?m0 ?m1) 1) 0.7799194) ")")))
)


(defrule Азот_Кислород_ОксидАзота1_ОксидАзота2_ОксидАзота3_ОксидАзота4_ОксидАзота5
   (declare (salience 40))
   (element (formula Азот) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидАзота1) (mass (* (/ (+ ?m0 ?m1) 5) 0.3087668))))
   (assert (element (formula ОксидАзота2) (mass (* (/ (+ ?m0 ?m1) 5) 0.3087668))))
   (assert (element (formula ОксидАзота3) (mass (* (/ (+ ?m0 ?m1) 5) 0.3087668))))
   (assert (element (formula ОксидАзота4) (mass (* (/ (+ ?m0 ?m1) 5) 0.3087668))))
   (assert (element (formula ОксидАзота5) (mass (* (/ (+ ?m0 ?m1) 5) 0.3087668))))
   (assert (appendmessagehalt (str-cat "N2 (" ?m0 ") + O2 (" ?m1 ") -(0.3087668)> N2O (" (* (/ (+ ?m0 ?m1) 5) 0.3087668) ") + NO (" (* (/ (+ ?m0 ?m1) 5) 0.3087668) ") + N2O3 (" (* (/ (+ ?m0 ?m1) 5) 0.3087668) ") + NO2 (" (* (/ (+ ?m0 ?m1) 5) 0.3087668) ") + N2O5 (" (* (/ (+ ?m0 ?m1) 5) 0.3087668) ")")))
)


(defrule ОксидАзота2_Кислород_ОксидАзота4
   (declare (salience 40))
   (element (formula ОксидАзота2) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидАзота4) (mass (* (/ (+ ?m0 ?m1) 1) 0.7427688))))
   (assert (appendmessagehalt (str-cat "NO (" ?m0 ") + O2 (" ?m1 ") -(0.7427688)> NO2 (" (* (/ (+ ?m0 ?m1) 1) 0.7427688) ")")))
)


(defrule Углерод_Кислород_УгарныйГаз_УглекислыйГаз_Тепло
   (declare (salience 40))
   (element (formula Углерод) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula УгарныйГаз) (mass (* (/ (+ ?m0 ?m1) 3) 0.6688216))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 3) 0.6688216))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 3) 0.6688216))))
   (assert (appendmessagehalt (str-cat "C (" ?m0 ") + O2 (" ?m1 ") -(0.6688216)> CO (" (* (/ (+ ?m0 ?m1) 3) 0.6688216) ") + CO2 (" (* (/ (+ ?m0 ?m1) 3) 0.6688216) ") + t (" (* (/ (+ ?m0 ?m1) 3) 0.6688216) ")")))
)


(defrule Натрий_Кислород_ОксидНатрия_Тепло
   (declare (salience 40))
   (element (formula Натрий) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3239676))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 2) 0.3239676))))
   (assert (appendmessagehalt (str-cat "Na (" ?m0 ") + O2 (" ?m1 ") -(0.3239676)> NaO (" (* (/ (+ ?m0 ?m1) 2) 0.3239676) ") + t (" (* (/ (+ ?m0 ?m1) 2) 0.3239676) ")")))
)


(defrule Калий_Кислород_ОксидКалия_Тепло
   (declare (salience 40))
   (element (formula Калий) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3007154))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 2) 0.3007154))))
   (assert (appendmessagehalt (str-cat "K (" ?m0 ") + O2 (" ?m1 ") -(0.3007154)> K2O (" (* (/ (+ ?m0 ?m1) 2) 0.3007154) ") + t (" (* (/ (+ ?m0 ?m1) 2) 0.3007154) ")")))
)


(defrule ТриоксидСеры_ДигидрогенаМонооксид_СернаяКислота
   (declare (salience 40))
   (element (formula ТриоксидСеры) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula СернаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.6429082))))
   (assert (appendmessagehalt (str-cat "SO3 (" ?m0 ") + H2O (" ?m1 ") -(0.6429082)> H2SO4 (" (* (/ (+ ?m0 ?m1) 1) 0.6429082) ")")))
)


(defrule СернаяКислота_Электролиз_ПероксодисернаяКислота_Водород
   (declare (salience 40))
   (element (formula СернаяКислота) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   =>
   (assert (element (formula ПероксодисернаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.4277372))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.4277372))))
   (assert (appendmessagehalt (str-cat "H2SO4 (" ?m0 ") + e (" ?m1 ") -(0.4277372)> H2S2O8 (" (* (/ (+ ?m0 ?m1) 2) 0.4277372) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.4277372) ")")))
)


(defrule ПероксодисернаяКислота_ДигидрогенаМонооксид_ПероксидВодорода_СернаяКислота
   (declare (salience 40))
   (element (formula ПероксодисернаяКислота) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ПероксидВодорода) (mass (* (/ (+ ?m0 ?m1) 2) 0.4125701))))
   (assert (element (formula СернаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.4125701))))
   (assert (appendmessagehalt (str-cat "H2S2O8 (" ?m0 ") + H2O (" ?m1 ") -(0.4125701)> H2O2 (" (* (/ (+ ?m0 ?m1) 2) 0.4125701) ") + H2SO4 (" (* (/ (+ ?m0 ?m1) 2) 0.4125701) ")")))
)


(defrule СолянаяКислота_ДиоксидСеры_ХлорсульфоноваяКислота
   (declare (salience 40))
   (element (formula СолянаяКислота) (mass ?m0))
   (element (formula ДиоксидСеры) (mass ?m1))
   =>
   (assert (element (formula ХлорсульфоноваяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.3928776))))
   (assert (appendmessagehalt (str-cat "HCl (" ?m0 ") + SO2 (" ?m1 ") -(0.3928776)> HSO3Cl (" (* (/ (+ ?m0 ?m1) 1) 0.3928776) ")")))
)


(defrule Водород_Хлор_СолянаяКислота
   (declare (salience 40))
   (element (formula Водород) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.6755655))))
   (assert (appendmessagehalt (str-cat "H2 (" ?m0 ") + Cl2 (" ?m1 ") -(0.6755655)> HCl (" (* (/ (+ ?m0 ?m1) 1) 0.6755655) ")")))
)


(defrule ГидроксидНатрия_Хлор_ХлоридНатрия_ГипохлоритНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидНатрия) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.5959818))))
   (assert (element (formula ГипохлоритНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.5959818))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.5959818))))
   (assert (appendmessagehalt (str-cat "NaOH (" ?m0 ") + Cl2 (" ?m1 ") -(0.5959818)> NaCl (" (* (/ (+ ?m0 ?m1) 3) 0.5959818) ") + NaOCl (" (* (/ (+ ?m0 ?m1) 3) 0.5959818) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.5959818) ")")))
)


(defrule Натрий_ДигидрогенаМонооксид_ГидроксидНатрия_Водород
   (declare (salience 40))
   (element (formula Натрий) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7570152))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.7570152))))
   (assert (appendmessagehalt (str-cat "Na (" ?m0 ") + H2O (" ?m1 ") -(0.7570152)> NaOH (" (* (/ (+ ?m0 ?m1) 2) 0.7570152) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.7570152) ")")))
)


(defrule ХлоридНатрия_СернаяКислота_ГидросульфатНатрия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридНатрия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula ГидросульфатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3083471))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.3083471))))
   (assert (appendmessagehalt (str-cat "NaCl (" ?m0 ") + H2SO4 (" ?m1 ") -(0.3083471)> NaHSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.3083471) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.3083471) ")")))
)


(defrule Калий_ДигидрогенаМонооксид_ГидроксидКалия
   (declare (salience 40))
   (element (formula Калий) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидКалия) (mass (* (/ (+ ?m0 ?m1) 1) 0.489677))))
   (assert (appendmessagehalt (str-cat "K (" ?m0 ") + H2O (" ?m1 ") -(0.489677)> KOH (" (* (/ (+ ?m0 ?m1) 1) 0.489677) ")")))
)


(defrule АзотнаяКислота_Свет_ОксидАзота2_ДигидрогенаМонооксид_Кислород
   (declare (salience 40))
   (element (formula АзотнаяКислота) (mass ?m0))
   (element (formula Свет) (mass ?m1))
   =>
   (assert (element (formula ОксидАзота2) (mass (* (/ (+ ?m0 ?m1) 3) 0.8885624))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.8885624))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 3) 0.8885624))))
   (assert (appendmessagehalt (str-cat "HNO3 (" ?m0 ") + hv (" ?m1 ") -(0.8885624)> NO (" (* (/ (+ ?m0 ?m1) 3) 0.8885624) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.8885624) ") + O2 (" (* (/ (+ ?m0 ?m1) 3) 0.8885624) ")")))
)


(defrule Метан_Кислород_ОксидАзота2_ДигидрогенаМонооксид_Тепло
   (declare (salience 40))
   (element (formula Метан) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидАзота2) (mass (* (/ (+ ?m0 ?m1) 3) 0.9035382))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.9035382))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 3) 0.9035382))))
   (assert (appendmessagehalt (str-cat "NH3 (" ?m0 ") + O2 (" ?m1 ") -(0.9035382)> NO (" (* (/ (+ ?m0 ?m1) 3) 0.9035382) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.9035382) ") + t (" (* (/ (+ ?m0 ?m1) 3) 0.9035382) ")")))
)


(defrule ОксидАзота4_Кислород_ДигидрогенаМонооксид_АзотнаяКислота_Тепло
   (declare (salience 40))
   (element (formula ОксидАзота4) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula ДигидрогенаМонооксид) (mass ?m2))
   =>
   (assert (element (formula АзотнаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.947922))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.947922))))
   (assert (appendmessagehalt (str-cat "NO2 (" ?m0 ") + O2 (" ?m1 ") + H2O (" ?m2 ") -(0.947922)> HNO3 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.947922) ") + t (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.947922) ")")))
)


(defrule Азот_Водород_Метан_Тепло
   (declare (salience 40))
   (element (formula Азот) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   =>
   (assert (element (formula Метан) (mass (* (/ (+ ?m0 ?m1) 2) 0.4593299))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1) 2) 0.4593299))))
   (assert (appendmessagehalt (str-cat "N2 (" ?m0 ") + H2 (" ?m1 ") -(0.4593299)> NH3 (" (* (/ (+ ?m0 ?m1) 2) 0.4593299) ") + t (" (* (/ (+ ?m0 ?m1) 2) 0.4593299) ")")))
)


(defrule Метан_Тепло_Азот_Водород
   (declare (salience 40))
   (element (formula Метан) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula Азот) (mass (* (/ (+ ?m0 ?m1) 2) 0.3066688))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.3066688))))
   (assert (appendmessagehalt (str-cat "NH3 (" ?m0 ") + t (" ?m1 ") -(0.3066688)> N2 (" (* (/ (+ ?m0 ?m1) 2) 0.3066688) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.3066688) ")")))
)


(defrule ДигидрогенаМонооксид_УглекислыйГаз_УгольнаяКислота
   (declare (salience 40))
   (element (formula ДигидрогенаМонооксид) (mass ?m0))
   (element (formula УглекислыйГаз) (mass ?m1))
   =>
   (assert (element (formula УгольнаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.6156793))))
   (assert (appendmessagehalt (str-cat "H2O (" ?m0 ") + CO2 (" ?m1 ") -(0.6156793)> H2CO3 (" (* (/ (+ ?m0 ?m1) 1) 0.6156793) ")")))
)


(defrule УгольнаяКислота_ДигидрогенаМонооксид_УглекислыйГаз
   (declare (salience 40))
   (element (formula УгольнаяКислота) (mass ?m0))
   =>
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ ?m0 2) 0.6340592))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ ?m0 2) 0.6340592))))
   (assert (appendmessagehalt (str-cat "H2CO3 (" ?m0 ") -(0.6340592)> H2O (" (* (/ ?m0 2) 0.6340592) ") + CO2 (" (* (/ ?m0 2) 0.6340592) ")")))
)


(defrule КарбонатНатрия_СолянаяКислота_ХлоридНатрия_УгольнаяКислота
   (declare (salience 40))
   (element (formula КарбонатНатрия) (mass ?m0))
   (element (formula СолянаяКислота) (mass ?m1))
   =>
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.4851709))))
   (assert (element (formula УгольнаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.4851709))))
   (assert (appendmessagehalt (str-cat "Na2CO3 (" ?m0 ") + HCl (" ?m1 ") -(0.4851709)> NaCl (" (* (/ (+ ?m0 ?m1) 2) 0.4851709) ") + H2CO3 (" (* (/ (+ ?m0 ?m1) 2) 0.4851709) ")")))
)


(defrule СиликатНатрия_СолянаяКислота_МетакремниеваяКислота_ХлоридНатрия
   (declare (salience 40))
   (element (formula СиликатНатрия) (mass ?m0))
   (element (formula СолянаяКислота) (mass ?m1))
   =>
   (assert (element (formula МетакремниеваяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.3856403))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3856403))))
   (assert (appendmessagehalt (str-cat "Na2SiO3 (" ?m0 ") + HCl (" ?m1 ") -(0.3856403)> H2SiO3 (" (* (/ (+ ?m0 ?m1) 2) 0.3856403) ") + NaCl (" (* (/ (+ ?m0 ?m1) 2) 0.3856403) ")")))
)


(defrule Дихлорсилан_ДигидрогенаМонооксид_СернистаяКислота_СолянаяКислота_Водород
   (declare (salience 40))
   (element (formula Дихлорсилан) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula СернистаяКислота) (mass (* (/ (+ ?m0 ?m1) 3) 0.7102435))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 3) 0.7102435))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 3) 0.7102435))))
   (assert (appendmessagehalt (str-cat "SiH2Cl2 (" ?m0 ") + H2O (" ?m1 ") -(0.7102435)> H2SO3 (" (* (/ (+ ?m0 ?m1) 3) 0.7102435) ") + HCl (" (* (/ (+ ?m0 ?m1) 3) 0.7102435) ") + H2 (" (* (/ (+ ?m0 ?m1) 3) 0.7102435) ")")))
)


(defrule ОксидАзота3_ДигидрогенаМонооксид_АзотистаяКислота
   (declare (salience 40))
   (element (formula ОксидАзота3) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula АзотистаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.880854))))
   (assert (appendmessagehalt (str-cat "N2O3 (" ?m0 ") + H2O (" ?m1 ") -(0.880854)> HNO2 (" (* (/ (+ ?m0 ?m1) 1) 0.880854) ")")))
)


(defrule ОксидАзота4_ДигидрогенаМонооксид_АзотнаяКислота_АзотистаяКислота
   (declare (salience 40))
   (element (formula ОксидАзота4) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula АзотнаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.4328692))))
   (assert (element (formula АзотистаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.4328692))))
   (assert (appendmessagehalt (str-cat "NO2 (" ?m0 ") + H2O (" ?m1 ") -(0.4328692)> HNO3 (" (* (/ (+ ?m0 ?m1) 2) 0.4328692) ") + HNO2 (" (* (/ (+ ?m0 ?m1) 2) 0.4328692) ")")))
)


(defrule Фосфор_АзотнаяКислота_ДигидрогенаМонооксид_ОртофосфорнаяКислота_ОксидАзота2
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula АзотнаяКислота) (mass ?m1))
   (element (formula ДигидрогенаМонооксид) (mass ?m2))
   =>
   (assert (element (formula ОртофосфорнаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.87753))))
   (assert (element (formula ОксидАзота2) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.87753))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + HNO3 (" ?m1 ") + H2O (" ?m2 ") -(0.87753)> H3PO4 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.87753) ") + NO (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.87753) ")")))
)


(defrule БелыйФосфор_Кислород_Тепло_ОксидФосфора
   (declare (salience 40))
   (element (formula БелыйФосфор) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидФосфора) (mass (* (/ (+ ?m0 ?m1 ?m2) 1) 0.6724645))))
   (assert (appendmessagehalt (str-cat "P4 (" ?m0 ") + O2 (" ?m1 ") + t (" ?m2 ") -(0.6724645)> P4O10 (" (* (/ (+ ?m0 ?m1 ?m2) 1) 0.6724645) ")")))
)


(defrule ОксидФосфора_ДигидрогенаМонооксид_ОртофосфорнаяКислота
   (declare (salience 40))
   (element (formula ОксидФосфора) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ОртофосфорнаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.8398992))))
   (assert (appendmessagehalt (str-cat "P4O10 (" ?m0 ") + H2O (" ?m1 ") -(0.8398992)> H3PO4 (" (* (/ (+ ?m0 ?m1) 1) 0.8398992) ")")))
)


(defrule ОксидФосфора3_ДигидрогенаМонооксид_ФосфористаяКислота
   (declare (salience 40))
   (element (formula ОксидФосфора3) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ФосфористаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.696079))))
   (assert (appendmessagehalt (str-cat "P2O3 (" ?m0 ") + H2O (" ?m1 ") -(0.696079)> H3PO3 (" (* (/ (+ ?m0 ?m1) 1) 0.696079) ")")))
)


(defrule ХлоридФосфора_ДигидрогенаМонооксид_ФосфористаяКислота_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридФосфора) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ФосфористаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.5488008))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.5488008))))
   (assert (appendmessagehalt (str-cat "PCl3 (" ?m0 ") + H2O (" ?m1 ") -(0.5488008)> H3PO3 (" (* (/ (+ ?m0 ?m1) 2) 0.5488008) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.5488008) ")")))
)


(defrule ГидрофосфатКалия_СолянаяКислота_ХлоридКалия_ФосфористаяКислота
   (declare (salience 40))
   (element (formula ГидрофосфатКалия) (mass ?m0))
   (element (formula СолянаяКислота) (mass ?m1))
   =>
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.8940021))))
   (assert (element (formula ФосфористаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.8940021))))
   (assert (appendmessagehalt (str-cat "K2HPO3 (" ?m0 ") + HCl (" ?m1 ") -(0.8940021)> KCl (" (* (/ (+ ?m0 ?m1) 2) 0.8940021) ") + H3PO3 (" (* (/ (+ ?m0 ?m1) 2) 0.8940021) ")")))
)


(defrule ОксидХрома_ДигидрогенаМонооксид_ХромоваяКислота_ДихромоваяКислота
   (declare (salience 40))
   (element (formula ОксидХрома) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ХромоваяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.8822851))))
   (assert (element (formula ДихромоваяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.8822851))))
   (assert (appendmessagehalt (str-cat "CrO3 (" ?m0 ") + H2O (" ?m1 ") -(0.8822851)> H2CrO4 (" (* (/ (+ ?m0 ?m1) 2) 0.8822851) ") + H2Cr2O7 (" (* (/ (+ ?m0 ?m1) 2) 0.8822851) ")")))
)


(defrule Хлор_ДигидрогенаМонооксид_ХлорноватистаяКислота_СолянаяКислота
   (declare (salience 40))
   (element (formula Хлор) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ХлорноватистаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.414343))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.414343))))
   (assert (appendmessagehalt (str-cat "Cl2 (" ?m0 ") + H2O (" ?m1 ") -(0.414343)> HClO (" (* (/ (+ ?m0 ?m1) 2) 0.414343) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.414343) ")")))
)


(defrule ОксидХлора_ДигидрогенаМонооксид_ХлорноватистаяКислота
   (declare (salience 40))
   (element (formula ОксидХлора) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ХлорноватистаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.8622164))))
   (assert (appendmessagehalt (str-cat "Cl2O (" ?m0 ") + H2O (" ?m1 ") -(0.8622164)> HClO (" (* (/ (+ ?m0 ?m1) 1) 0.8622164) ")")))
)


(defrule ОксидХлора_ПероксидВодорода_ГидроксидНатрия_ХлоритНатрия_Кислород_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидХлора) (mass ?m0))
   (element (formula ПероксидВодорода) (mass ?m1))
   (element (formula ГидроксидНатрия) (mass ?m2))
   =>
   (assert (element (formula ХлоритНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.5662515))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.5662515))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.5662515))))
   (assert (appendmessagehalt (str-cat "ClO2 (" ?m0 ") + H2O2 (" ?m1 ") + NaOH (" ?m2 ") -(0.5662515)> NaClO2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.5662515) ") + O2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.5662515) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.5662515) ")")))
)


(defrule ГипохлоритБария_СернаяКислота_СульфатБария_ХлористаяКислота
   (declare (salience 40))
   (element (formula ГипохлоритБария) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula СульфатБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.4882237))))
   (assert (element (formula ХлористаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.4882237))))
   (assert (appendmessagehalt (str-cat "Ba(ClO2)2 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.4882237)> BaSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.4882237) ") + HClO2 (" (* (/ (+ ?m0 ?m1) 2) 0.4882237) ")")))
)


(defrule ХлоратБария_СернаяКислота_СульфатБария_ХлорноватаяКислота
   (declare (salience 40))
   (element (formula ХлоратБария) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula СульфатБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.8826085))))
   (assert (element (formula ХлорноватаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.8826085))))
   (assert (appendmessagehalt (str-cat "Ba(ClO3)2 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.8826085)> BaSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.8826085) ") + HClO3 (" (* (/ (+ ?m0 ?m1) 2) 0.8826085) ")")))
)


(defrule ПерхлоратКалия_СернаяКислота_ГидросульфатКалия_ХлорнаяКислота
   (declare (salience 40))
   (element (formula ПерхлоратКалия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula ГидросульфатКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7487454))))
   (assert (element (formula ХлорнаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.7487454))))
   (assert (appendmessagehalt (str-cat "KClO4 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.7487454)> KHSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.7487454) ") + HClO4 (" (* (/ (+ ?m0 ?m1) 2) 0.7487454) ")")))
)


(defrule ПерманганатБария_СернаяКислота_МарганцоваяКислота_СульфатБария
   (declare (salience 40))
   (element (formula ПерманганатБария) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula МарганцоваяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.4834546))))
   (assert (element (formula СульфатБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.4834546))))
   (assert (appendmessagehalt (str-cat "Ba(MnO4)2 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.4834546)> HMnO4 (" (* (/ (+ ?m0 ?m1) 2) 0.4834546) ") + BaSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.4834546) ")")))
)


(defrule ОксидМарганца_ДигидрогенаМонооксид_МарганцоваяКислота
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula МарганцоваяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.4862997))))
   (assert (appendmessagehalt (str-cat "Mn2O7 (" ?m0 ") + H2O (" ?m1 ") -(0.4862997)> HMnO4 (" (* (/ (+ ?m0 ?m1) 1) 0.4862997) ")")))
)


(defrule СульфатНатрия_Углерод_СульфидНатрия_УглекислыйГаз
   (declare (salience 40))
   (element (formula СульфатНатрия) (mass ?m0))
   (element (formula Углерод) (mass ?m1))
   =>
   (assert (element (formula СульфидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.5858159))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.5858159))))
   (assert (appendmessagehalt (str-cat "Na2SO4 (" ?m0 ") + C (" ?m1 ") -(0.5858159)> Na2S (" (* (/ (+ ?m0 ?m1) 2) 0.5858159) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.5858159) ")")))
)


(defrule СульфидНатрия_КарбонатКальция_КарбонатНатрия_СульфидКальция
   (declare (salience 40))
   (element (formula СульфидНатрия) (mass ?m0))
   (element (formula КарбонатКальция) (mass ?m1))
   =>
   (assert (element (formula КарбонатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.6352158))))
   (assert (element (formula СульфидКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.6352158))))
   (assert (appendmessagehalt (str-cat "Na2S (" ?m0 ") + CaCO3 (" ?m1 ") -(0.6352158)> Na2CO3 (" (* (/ (+ ?m0 ?m1) 2) 0.6352158) ") + CaS (" (* (/ (+ ?m0 ?m1) 2) 0.6352158) ")")))
)


(defrule ХлоридНатрия_СернаяКислота_СульфатНатрия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридНатрия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula СульфатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.5024664))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.5024664))))
   (assert (appendmessagehalt (str-cat "NaCl (" ?m0 ") + H2SO4 (" ?m1 ") -(0.5024664)> Na2SO4 (" (* (/ (+ ?m0 ?m1) 2) 0.5024664) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.5024664) ")")))
)


(defrule Метан_УглекислыйГаз_ДигидрогенаМонооксид_ХлоридНатрия_ГидрокарбонатНатрия_ХлоридАммония
   (declare (salience 40))
   (element (formula Метан) (mass ?m0))
   (element (formula УглекислыйГаз) (mass ?m1))
   (element (formula ДигидрогенаМонооксид) (mass ?m2))
   (element (formula ХлоридНатрия) (mass ?m3))
   =>
   (assert (element (formula ГидрокарбонатНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.5910046))))
   (assert (element (formula ХлоридАммония) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.5910046))))
   (assert (appendmessagehalt (str-cat "NH3 (" ?m0 ") + CO2 (" ?m1 ") + H2O (" ?m2 ") + NaCl (" ?m3 ") -(0.5910046)> NaHCO3 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.5910046) ") + HN4Cl (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.5910046) ")")))
)


(defrule ГидрокарбонатНатрия_Тепло_КарбонатНатрия_ДигидрогенаМонооксид_УглекислыйГаз
   (declare (salience 40))
   (element (formula ГидрокарбонатНатрия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula КарбонатНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.4163508))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.4163508))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 3) 0.4163508))))
   (assert (appendmessagehalt (str-cat "NaHCO3 (" ?m0 ") + t (" ?m1 ") -(0.4163508)> Na2CO3 (" (* (/ (+ ?m0 ?m1) 3) 0.4163508) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.4163508) ") + CO2 (" (* (/ (+ ?m0 ?m1) 3) 0.4163508) ")")))
)


(defrule ОксидКремния_ГидроксидНатрия_СиликатНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидКремния) (mass ?m0))
   (element (formula ГидроксидНатрия) (mass ?m1))
   =>
   (assert (element (formula СиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7762617))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.7762617))))
   (assert (appendmessagehalt (str-cat "SiO2 (" ?m0 ") + NaOH (" ?m1 ") -(0.7762617)> Na2SiO3 (" (* (/ (+ ?m0 ?m1) 2) 0.7762617) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.7762617) ")")))
)


(defrule ОксидКремния_КарбонатНатрия_СиликатНатрия_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидКремния) (mass ?m0))
   (element (formula КарбонатНатрия) (mass ?m1))
   =>
   (assert (element (formula СиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.4338714))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.4338714))))
   (assert (appendmessagehalt (str-cat "SiO2 (" ?m0 ") + Na2CO3 (" ?m1 ") -(0.4338714)> Na2SiO3 (" (* (/ (+ ?m0 ?m1) 2) 0.4338714) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.4338714) ")")))
)


(defrule ОртосиликатНатрия_Тепло_СиликатНатрия_ОксидНатрия
   (declare (salience 40))
   (element (formula ОртосиликатНатрия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula СиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7867498))))
   (assert (element (formula ОксидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7867498))))
   (assert (appendmessagehalt (str-cat "Na4SiO4 (" ?m0 ") + t (" ?m1 ") -(0.7867498)> Na2SiO3 (" (* (/ (+ ?m0 ?m1) 2) 0.7867498) ") + Na2O (" (* (/ (+ ?m0 ?m1) 2) 0.7867498) ")")))
)


(defrule СлоридАммония_ГидроксидНатрия_Метан_ХлоридНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СлоридАммония) (mass ?m0))
   (element (formula ГидроксидНатрия) (mass ?m1))
   =>
   (assert (element (formula Метан) (mass (* (/ (+ ?m0 ?m1) 3) 0.4501759))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.4501759))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.4501759))))
   (assert (appendmessagehalt (str-cat "NH4Cl (" ?m0 ") + NaOH (" ?m1 ") -(0.4501759)> NH3 (" (* (/ (+ ?m0 ?m1) 3) 0.4501759) ") + NaCl (" (* (/ (+ ?m0 ?m1) 3) 0.4501759) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.4501759) ")")))
)


(defrule МетафосфорнаяКислота_Углерод_БелыйФосфор_ДигидрогенаМонооксид_УгарныйГаз
   (declare (salience 40))
   (element (formula МетафосфорнаяКислота) (mass ?m0))
   (element (formula Углерод) (mass ?m1))
   =>
   (assert (element (formula БелыйФосфор) (mass (* (/ (+ ?m0 ?m1) 3) 0.5250228))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.5250228))))
   (assert (element (formula УгарныйГаз) (mass (* (/ (+ ?m0 ?m1) 3) 0.5250228))))
   (assert (appendmessagehalt (str-cat "HPO3 (" ?m0 ") + C (" ?m1 ") -(0.5250228)> P4 (" (* (/ (+ ?m0 ?m1) 3) 0.5250228) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.5250228) ") + CO (" (* (/ (+ ?m0 ?m1) 3) 0.5250228) ")")))
)


(defrule Фосфор_Кислород_ОксидФосфора5_ОксидФосфора3
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидФосфора5) (mass (* (/ (+ ?m0 ?m1) 2) 0.5500866))))
   (assert (element (formula ОксидФосфора3) (mass (* (/ (+ ?m0 ?m1) 2) 0.5500866))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + O2 (" ?m1 ") -(0.5500866)> P2O5 (" (* (/ (+ ?m0 ?m1) 2) 0.5500866) ") + P2O3 (" (* (/ (+ ?m0 ?m1) 2) 0.5500866) ")")))
)


(defrule Фосфор_Кальций_ФосфидКальция
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula Кальций) (mass ?m1))
   =>
   (assert (element (formula ФосфидКальция) (mass (* (/ (+ ?m0 ?m1) 1) 0.8324365))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + Ca (" ?m1 ") -(0.8324365)> Ca3P2 (" (* (/ (+ ?m0 ?m1) 1) 0.8324365) ")")))
)


(defrule Фосфор_Сера_СульфидФосфора
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula Сера) (mass ?m1))
   =>
   (assert (element (formula СульфидФосфора) (mass (* (/ (+ ?m0 ?m1) 1) 0.8719187))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + S (" ?m1 ") -(0.8719187)> P2S3 (" (* (/ (+ ?m0 ?m1) 1) 0.8719187) ")")))
)


(defrule Фосфор_Хлор_ХлоридФосфора_ХлоридФосфора
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ХлоридФосфора) (mass (* (/ (+ ?m0 ?m1) 2) 0.4458602))))
   (assert (element (formula ХлоридФосфора) (mass (* (/ (+ ?m0 ?m1) 2) 0.4458602))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + Cl2 (" ?m1 ") -(0.4458602)> PCl3 (" (* (/ (+ ?m0 ?m1) 2) 0.4458602) ") + PCl5 (" (* (/ (+ ?m0 ?m1) 2) 0.4458602) ")")))
)


(defrule Фосфор_ДигидрогенаМонооксид_Тепло_Фосфин_ОртофосфорнаяКислота
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Фосфин) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.7735959))))
   (assert (element (formula ОртофосфорнаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.7735959))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + H2O (" ?m1 ") + t (" ?m2 ") -(0.7735959)> PH3 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.7735959) ") + H3PO4 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.7735959) ")")))
)


(defrule Фосфор_ДигидрогенаМонооксид_Тепло_ОртофосфорнаяКислота_Водород
   (declare (salience 40))
   (element (formula Фосфор) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОртофосфорнаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.6571285))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.6571285))))
   (assert (appendmessagehalt (str-cat "P (" ?m0 ") + H2O (" ?m1 ") + t (" ?m2 ") -(0.6571285)> H3PO4 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.6571285) ") + H2 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.6571285) ")")))
)


(defrule БелыйФосфор_Тепло_Фосфор
   (declare (salience 40))
   (element (formula БелыйФосфор) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula Фосфор) (mass (* (/ (+ ?m0 ?m1) 1) 0.9085781))))
   (assert (appendmessagehalt (str-cat "P4 (" ?m0 ") + t (" ?m1 ") -(0.9085781)> P (" (* (/ (+ ?m0 ?m1) 1) 0.9085781) ")")))
)


(defrule БелыйФосфор_Свет_Фосфор
   (declare (salience 40))
   (element (formula БелыйФосфор) (mass ?m0))
   (element (formula Свет) (mass ?m1))
   =>
   (assert (element (formula Фосфор) (mass (* (/ (+ ?m0 ?m1) 1) 0.3931136))))
   (assert (appendmessagehalt (str-cat "P4 (" ?m0 ") + hv (" ?m1 ") -(0.3931136)> P (" (* (/ (+ ?m0 ?m1) 1) 0.3931136) ")")))
)


(defrule БелыйФосфор_ОксидАзота1_ОксидФосфора_Азот
   (declare (salience 40))
   (element (formula БелыйФосфор) (mass ?m0))
   (element (formula ОксидАзота1) (mass ?m1))
   =>
   (assert (element (formula ОксидФосфора) (mass (* (/ (+ ?m0 ?m1) 2) 0.8178462))))
   (assert (element (formula Азот) (mass (* (/ (+ ?m0 ?m1) 2) 0.8178462))))
   (assert (appendmessagehalt (str-cat "P4 (" ?m0 ") + N2O (" ?m1 ") -(0.8178462)> P4O5 (" (* (/ (+ ?m0 ?m1) 2) 0.8178462) ") + N2 (" (* (/ (+ ?m0 ?m1) 2) 0.8178462) ")")))
)


(defrule БелыйФосфор_УглекислыйГаз_ОксидФосфора_УгарныйГаз
   (declare (salience 40))
   (element (formula БелыйФосфор) (mass ?m0))
   (element (formula УглекислыйГаз) (mass ?m1))
   =>
   (assert (element (formula ОксидФосфора) (mass (* (/ (+ ?m0 ?m1) 2) 0.7153782))))
   (assert (element (formula УгарныйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.7153782))))
   (assert (appendmessagehalt (str-cat "P4 (" ?m0 ") + CO2 (" ?m1 ") -(0.7153782)> P4O5 (" (* (/ (+ ?m0 ?m1) 2) 0.7153782) ") + CO (" (* (/ (+ ?m0 ?m1) 2) 0.7153782) ")")))
)


(defrule ДихроматНатрия_СернаяКислота_ОксидХрома_СульфатНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ДихроматНатрия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula ОксидХрома) (mass (* (/ (+ ?m0 ?m1) 3) 0.7052727))))
   (assert (element (formula СульфатНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.7052727))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.7052727))))
   (assert (appendmessagehalt (str-cat "Na2Cr2O7 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.7052727)> CrO3 (" (* (/ (+ ?m0 ?m1) 3) 0.7052727) ") + Na2SO4 (" (* (/ (+ ?m0 ?m1) 3) 0.7052727) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.7052727) ")")))
)


(defrule ОксидРтути_Хлор_ГипохлоридРтути_ОксидХлора
   (declare (salience 40))
   (element (formula ОксидРтути) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ГипохлоридРтути) (mass (* (/ (+ ?m0 ?m1) 2) 0.5226709))))
   (assert (element (formula ОксидХлора) (mass (* (/ (+ ?m0 ?m1) 2) 0.5226709))))
   (assert (appendmessagehalt (str-cat "HgO (" ?m0 ") + Cl2 (" ?m1 ") -(0.5226709)> Hg2OCl2 (" (* (/ (+ ?m0 ?m1) 2) 0.5226709) ") + Cl2O (" (* (/ (+ ?m0 ?m1) 2) 0.5226709) ")")))
)


(defrule ОксидРтути_Хлор_ХлоридРтути_ОксидХлора
   (declare (salience 40))
   (element (formula ОксидРтути) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ХлоридРтути) (mass (* (/ (+ ?m0 ?m1) 2) 0.6467987))))
   (assert (element (formula ОксидХлора) (mass (* (/ (+ ?m0 ?m1) 2) 0.6467987))))
   (assert (appendmessagehalt (str-cat "HgO (" ?m0 ") + Cl2 (" ?m1 ") -(0.6467987)> HgCl2 (" (* (/ (+ ?m0 ?m1) 2) 0.6467987) ") + Cl2O (" (* (/ (+ ?m0 ?m1) 2) 0.6467987) ")")))
)


(defrule Хлор_КарбонатНатрия_ДигидрогенаМонооксид_ГидрокарбонатНатрия_ХлоридНатрия_ОксидХлора
   (declare (salience 40))
   (element (formula Хлор) (mass ?m0))
   (element (formula КарбонатНатрия) (mass ?m1))
   (element (formula ДигидрогенаМонооксид) (mass ?m2))
   =>
   (assert (element (formula ГидрокарбонатНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4267648))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4267648))))
   (assert (element (formula ОксидХлора) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4267648))))
   (assert (appendmessagehalt (str-cat "Cl2 (" ?m0 ") + Na2CO3 (" ?m1 ") + H2O (" ?m2 ") -(0.4267648)> NaHCO3 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4267648) ") + NaCl (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4267648) ") + Cl2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.4267648) ")")))
)


(defrule ХлоратКалия_ЩавелеваяКислота_ОксидХлора_КарбонатКалия_УглекислыйГаз_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ХлоратКалия) (mass ?m0))
   (element (formula ЩавелеваяКислота) (mass ?m1))
   =>
   (assert (element (formula ОксидХлора) (mass (* (/ (+ ?m0 ?m1) 4) 0.6519798))))
   (assert (element (formula КарбонатКалия) (mass (* (/ (+ ?m0 ?m1) 4) 0.6519798))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 4) 0.6519798))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 4) 0.6519798))))
   (assert (appendmessagehalt (str-cat "KClO3 (" ?m0 ") + H2C2O4 (" ?m1 ") -(0.6519798)> ClO2 (" (* (/ (+ ?m0 ?m1) 4) 0.6519798) ") + K2CO3 (" (* (/ (+ ?m0 ?m1) 4) 0.6519798) ") + CO2 (" (* (/ (+ ?m0 ?m1) 4) 0.6519798) ") + H2O (" (* (/ (+ ?m0 ?m1) 4) 0.6519798) ")")))
)


(defrule ХлоратНатрия_ДиоксидСеры_СернаяКислота_ГидросульфатНатрия_ОксидХлора
   (declare (salience 40))
   (element (formula ХлоратНатрия) (mass ?m0))
   (element (formula ДиоксидСеры) (mass ?m1))
   (element (formula СернаяКислота) (mass ?m2))
   =>
   (assert (element (formula ГидросульфатНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.8247302))))
   (assert (element (formula ОксидХлора) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.8247302))))
   (assert (appendmessagehalt (str-cat "NaClO3 (" ?m0 ") + SO2 (" ?m1 ") + H2SO4 (" ?m2 ") -(0.8247302)> NaHSO4 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.8247302) ") + ClO2 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.8247302) ")")))
)


(defrule ГидроксидБария_Хлор_ГипохлоритБария_ХлоридБария_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидБария) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ГипохлоритБария) (mass (* (/ (+ ?m0 ?m1) 3) 0.8440042))))
   (assert (element (formula ХлоридБария) (mass (* (/ (+ ?m0 ?m1) 3) 0.8440042))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.8440042))))
   (assert (appendmessagehalt (str-cat "Ba(OH)2 (" ?m0 ") + Cl2 (" ?m1 ") -(0.8440042)> Ba(ClO)2 (" (* (/ (+ ?m0 ?m1) 3) 0.8440042) ") + BaCl2 (" (* (/ (+ ?m0 ?m1) 3) 0.8440042) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.8440042) ")")))
)


(defrule ХлоридБария_ДигидрогенаМонооксид_ГидроксидБария_Водород_Хлор
   (declare (salience 40))
   (element (formula ХлоридБария) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидБария) (mass (* (/ (+ ?m0 ?m1) 3) 0.5774605))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 3) 0.5774605))))
   (assert (element (formula Хлор) (mass (* (/ (+ ?m0 ?m1) 3) 0.5774605))))
   (assert (appendmessagehalt (str-cat "BaCl2 (" ?m0 ") + H2O (" ?m1 ") -(0.5774605)> Ba(OH)2 (" (* (/ (+ ?m0 ?m1) 3) 0.5774605) ") + H2 (" (* (/ (+ ?m0 ?m1) 3) 0.5774605) ") + Cl2 (" (* (/ (+ ?m0 ?m1) 3) 0.5774605) ")")))
)


(defrule ГидроксидБария_Хлор_ХлоридБария_ХлоратБария_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидБария) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ХлоридБария) (mass (* (/ (+ ?m0 ?m1) 3) 0.6223109))))
   (assert (element (formula ХлоратБария) (mass (* (/ (+ ?m0 ?m1) 3) 0.6223109))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.6223109))))
   (assert (appendmessagehalt (str-cat "Ba(OH)2 (" ?m0 ") + Cl2 (" ?m1 ") -(0.6223109)> BaCl2 (" (* (/ (+ ?m0 ?m1) 3) 0.6223109) ") + Ba(ClO3)2 (" (* (/ (+ ?m0 ?m1) 3) 0.6223109) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.6223109) ")")))
)


(defrule ПерхлоратНатрия_ХлоридКалия_ПерхлоратКалия_ХлоридНатрия
   (declare (salience 40))
   (element (formula ПерхлоратНатрия) (mass ?m0))
   (element (formula ХлоридКалия) (mass ?m1))
   =>
   (assert (element (formula ПерхлоратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7153144))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7153144))))
   (assert (appendmessagehalt (str-cat "NaClO4 (" ?m0 ") + KCl (" ?m1 ") -(0.7153144)> KClO4 (" (* (/ (+ ?m0 ?m1) 2) 0.7153144) ") + NaCl (" (* (/ (+ ?m0 ?m1) 2) 0.7153144) ")")))
)


(defrule ХлоратКалия_Электролиз_ПерхлоратКалия_ХлоридКалия
   (declare (salience 40))
   (element (formula ХлоратКалия) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   =>
   (assert (element (formula ПерхлоратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3653135))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3653135))))
   (assert (appendmessagehalt (str-cat "KClO3 (" ?m0 ") + e (" ?m1 ") -(0.3653135)> KClO4 (" (* (/ (+ ?m0 ?m1) 2) 0.3653135) ") + KCl (" (* (/ (+ ?m0 ?m1) 2) 0.3653135) ")")))
)


(defrule ХлоратКалия_Тепло_ПерхлоратКалия_ХлоридКалия
   (declare (salience 40))
   (element (formula ХлоратКалия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ПерхлоратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.6605845))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.6605845))))
   (assert (appendmessagehalt (str-cat "KClO3 (" ?m0 ") + t (" ?m1 ") -(0.6605845)> KClO4 (" (* (/ (+ ?m0 ?m1) 2) 0.6605845) ") + KCl (" (* (/ (+ ?m0 ?m1) 2) 0.6605845) ")")))
)


(defrule ПерманганатКалия_СернаяКислота_ОксидМарганца_СульфатКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ПерманганатКалия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula ОксидМарганца) (mass (* (/ (+ ?m0 ?m1) 3) 0.7732141))))
   (assert (element (formula СульфатКалия) (mass (* (/ (+ ?m0 ?m1) 3) 0.7732141))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.7732141))))
   (assert (appendmessagehalt (str-cat "KMnO4 (" ?m0 ") + H2SO4 (" ?m1 ") -(0.7732141)> Mn2O7 (" (* (/ (+ ?m0 ?m1) 3) 0.7732141) ") + K2SO4 (" (* (/ (+ ?m0 ?m1) 3) 0.7732141) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.7732141) ")")))
)


(defrule ОксидМарганца_ОксидМарганца_Кислород_Озон_Тепло
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   =>
   (assert (element (formula ОксидМарганца) (mass (* (/ ?m0 4) 0.4293796))))
   (assert (element (formula Кислород) (mass (* (/ ?m0 4) 0.4293796))))
   (assert (element (formula Озон) (mass (* (/ ?m0 4) 0.4293796))))
   (assert (element (formula Тепло) (mass (* (/ ?m0 4) 0.4293796))))
   (assert (appendmessagehalt (str-cat "Mn2O7 (" ?m0 ") -(0.4293796)> MnO2 (" (* (/ ?m0 4) 0.4293796) ") + O2 (" (* (/ ?m0 4) 0.4293796) ") + O3 (" (* (/ ?m0 4) 0.4293796) ") + t (" (* (/ ?m0 4) 0.4293796) ")")))
)


(defrule ОксидМарганца_ДигидрогенаМонооксид_МарганцоваяКислота
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula МарганцоваяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.3482433))))
   (assert (appendmessagehalt (str-cat "Mn2O7 (" ?m0 ") + H2O (" ?m1 ") -(0.3482433)> HMnO4 (" (* (/ (+ ?m0 ?m1) 1) 0.3482433) ")")))
)


(defrule ХлоридНатрия_СернаяКислота_СульфатНатрия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридНатрия) (mass ?m0))
   (element (formula СернаяКислота) (mass ?m1))
   =>
   (assert (element (formula СульфатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7999551))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.7999551))))
   (assert (appendmessagehalt (str-cat "NaCl (" ?m0 ") + H2SO4 (" ?m1 ") -(0.7999551)> Na2SO4 (" (* (/ (+ ?m0 ?m1) 2) 0.7999551) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.7999551) ")")))
)


(defrule ОксидКальция_ДигидрогенаМонооксид_ГидроксидКальция
   (declare (salience 40))
   (element (formula ОксидКальция) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидКальция) (mass (* (/ (+ ?m0 ?m1) 1) 0.8331739))))
   (assert (appendmessagehalt (str-cat "CaO (" ?m0 ") + H2O (" ?m1 ") -(0.8331739)> Ca(OH)2 (" (* (/ (+ ?m0 ?m1) 1) 0.8331739) ")")))
)


(defrule ГидроксидКальция_УглекислыйГаз_КарбонатКальция_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидКальция) (mass ?m0))
   (element (formula УглекислыйГаз) (mass ?m1))
   =>
   (assert (element (formula КарбонатКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.4192389))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.4192389))))
   (assert (appendmessagehalt (str-cat "Ca(OH)2 (" ?m0 ") + CO2 (" ?m1 ") -(0.4192389)> CaCO3 (" (* (/ (+ ?m0 ?m1) 2) 0.4192389) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.4192389) ")")))
)


(defrule Кремний_ГидроксидНатрия_ОртосиликатНатрия_Водород
   (declare (salience 40))
   (element (formula Кремний) (mass ?m0))
   (element (formula ГидроксидНатрия) (mass ?m1))
   =>
   (assert (element (formula ОртосиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7645032))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.7645032))))
   (assert (appendmessagehalt (str-cat "Si (" ?m0 ") + NaOH (" ?m1 ") -(0.7645032)> Na4SiO4 (" (* (/ (+ ?m0 ?m1) 2) 0.7645032) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.7645032) ")")))
)


(defrule ОксидКремния_ГидроксидНатрия_ОртосиликатНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидКремния) (mass ?m0))
   (element (formula ГидроксидНатрия) (mass ?m1))
   =>
   (assert (element (formula ОртосиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.6066075))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.6066075))))
   (assert (appendmessagehalt (str-cat "SiO2 (" ?m0 ") + NaOH (" ?m1 ") -(0.6066075)> Na4SiO4 (" (* (/ (+ ?m0 ?m1) 2) 0.6066075) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.6066075) ")")))
)


(defrule ОксидКремния_КарбонатНатрия_ОртосиликатНатрия_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидКремния) (mass ?m0))
   (element (formula КарбонатНатрия) (mass ?m1))
   =>
   (assert (element (formula ОртосиликатНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7436586))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.7436586))))
   (assert (appendmessagehalt (str-cat "SiO2 (" ?m0 ") + Na2CO3 (" ?m1 ") -(0.7436586)> Na4SiO4 (" (* (/ (+ ?m0 ?m1) 2) 0.7436586) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.7436586) ")")))
)


(defrule ОксидФосфора_ОксидФосфора5
   (declare (salience 40))
   (element (formula ОксидФосфора) (mass ?m0))
   =>
   (assert (element (formula ОксидФосфора5) (mass (* (/ ?m0 1) 0.8357147))))
   (assert (appendmessagehalt (str-cat "P4O10 (" ?m0 ") -(0.8357147)> P2O5 (" (* (/ ?m0 1) 0.8357147) ")")))
)


(defrule ОксидФосфора5_ОксидФосфора
   (declare (salience 40))
   (element (formula ОксидФосфора5) (mass ?m0))
   =>
   (assert (element (formula ОксидФосфора) (mass (* (/ ?m0 1) 0.6897234))))
   (assert (appendmessagehalt (str-cat "P2O5 (" ?m0 ") -(0.6897234)> P4O10 (" (* (/ ?m0 1) 0.6897234) ")")))
)


(defrule ОксидФосфора5_ДигидрогенаМонооксид_МетафосфорнаяКислота
   (declare (salience 40))
   (element (formula ОксидФосфора5) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula МетафосфорнаяКислота) (mass (* (/ (+ ?m0 ?m1) 1) 0.4710562))))
   (assert (appendmessagehalt (str-cat "P2O5 (" ?m0 ") + H2O (" ?m1 ") -(0.4710562)> HPO3 (" (* (/ (+ ?m0 ?m1) 1) 0.4710562) ")")))
)


(defrule СолянаяКислота_ГидроксидКалия_ХлоридКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СолянаяКислота) (mass ?m0))
   (element (formula ГидроксидКалия) (mass ?m1))
   =>
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.9487142))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.9487142))))
   (assert (appendmessagehalt (str-cat "HCl (" ?m0 ") + KOH (" ?m1 ") -(0.9487142)> KCl (" (* (/ (+ ?m0 ?m1) 2) 0.9487142) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.9487142) ")")))
)


(defrule ОксидХрома_КарбонатНатрия_Кислород_Тепло_ДихроматНатрия
   (declare (salience 40))
   (element (formula ОксидХрома) (mass ?m0))
   (element (formula КарбонатНатрия) (mass ?m1))
   (element (formula Кислород) (mass ?m2))
   (element (formula Тепло) (mass ?m3))
   =>
   (assert (element (formula ДихроматНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 1) 0.3615655))))
   (assert (appendmessagehalt (str-cat "Cr2O3 (" ?m0 ") + Na2CO3 (" ?m1 ") + O2 (" ?m2 ") + t (" ?m3 ") -(0.3615655)> Na2Cr2O7 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 1) 0.3615655) ")")))
)


(defrule Ртуть_Кислород_Тепло_ОксидРтути
   (declare (salience 40))
   (element (formula Ртуть) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидРтути) (mass (* (/ (+ ?m0 ?m1 ?m2) 1) 0.3103664))))
   (assert (appendmessagehalt (str-cat "Hg (" ?m0 ") + O2 (" ?m1 ") + t (" ?m2 ") -(0.3103664)> HgO (" (* (/ (+ ?m0 ?m1 ?m2) 1) 0.3103664) ")")))
)


(defrule СульфидРтути_ГидроксидНатрия_ОксидРтути_СульфидНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СульфидРтути) (mass ?m0))
   (element (formula ГидроксидНатрия) (mass ?m1))
   =>
   (assert (element (formula ОксидРтути) (mass (* (/ (+ ?m0 ?m1) 3) 0.9184827))))
   (assert (element (formula СульфидНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.9184827))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.9184827))))
   (assert (appendmessagehalt (str-cat "HgS (" ?m0 ") + NaOH (" ?m1 ") -(0.9184827)> HgO (" (* (/ (+ ?m0 ?m1) 3) 0.9184827) ") + Na2S (" (* (/ (+ ?m0 ?m1) 3) 0.9184827) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.9184827) ")")))
)


(defrule СульфидРтути_Кислород_Тепло_Ртуть_ДиоксидСеры
   (declare (salience 40))
   (element (formula СульфидРтути) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Ртуть) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.3886205))))
   (assert (element (formula ДиоксидСеры) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.3886205))))
   (assert (appendmessagehalt (str-cat "HgS (" ?m0 ") + O2 (" ?m1 ") + t (" ?m2 ") -(0.3886205)> Hg (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.3886205) ") + SO2 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.3886205) ")")))
)


(defrule СульфидРтути_Железо_Тепло_Ртуть_ОксидЖелеза3
   (declare (salience 40))
   (element (formula СульфидРтути) (mass ?m0))
   (element (formula Железо) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Ртуть) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.859123))))
   (assert (element (formula ОксидЖелеза3) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.859123))))
   (assert (appendmessagehalt (str-cat "HgS (" ?m0 ") + Fe (" ?m1 ") + t (" ?m2 ") -(0.859123)> Hg (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.859123) ") + Fe2O3 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.859123) ")")))
)


(defrule Хлор_ГидроксидКалия_ХлоратКалия_ХлоридКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Хлор) (mass ?m0))
   (element (formula ГидроксидКалия) (mass ?m1))
   =>
   (assert (element (formula ХлоратКалия) (mass (* (/ (+ ?m0 ?m1) 3) 0.5296456))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 3) 0.5296456))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.5296456))))
   (assert (appendmessagehalt (str-cat "Cl2 (" ?m0 ") + KOH (" ?m1 ") -(0.5296456)> KClO3 (" (* (/ (+ ?m0 ?m1) 3) 0.5296456) ") + KCl (" (* (/ (+ ?m0 ?m1) 3) 0.5296456) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.5296456) ")")))
)


(defrule ХлоратНатрия_ХлорноватаяКислота_ХлоратНатрия_ДигидрогенаМонооксид_УглекислыйГаз
   (declare (salience 40))
   (element (formula ХлоратНатрия) (mass ?m0))
   (element (formula ХлорноватаяКислота) (mass ?m1))
   =>
   (assert (element (formula ХлоратНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.7894949))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.7894949))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 3) 0.7894949))))
   (assert (appendmessagehalt (str-cat "Na2ClO3 (" ?m0 ") + HClO3 (" ?m1 ") -(0.7894949)> NaClO3 (" (* (/ (+ ?m0 ?m1) 3) 0.7894949) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.7894949) ") + CO2 (" (* (/ (+ ?m0 ?m1) 3) 0.7894949) ")")))
)


(defrule ГидроксидНатрия_Хлор_ХлоратНатрия_ХлоридНатрия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидНатрия) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ХлоратНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.8808991))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 3) 0.8808991))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.8808991))))
   (assert (appendmessagehalt (str-cat "NaOH (" ?m0 ") + Cl2 (" ?m1 ") -(0.8808991)> NaClO3 (" (* (/ (+ ?m0 ?m1) 3) 0.8808991) ") + NaCl (" (* (/ (+ ?m0 ?m1) 3) 0.8808991) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.8808991) ")")))
)


(defrule ХлоридНатрия_ДигидрогенаМонооксид_Электролиз_ХлоратНатрия_ХлоридНатрия_Водород
   (declare (salience 40))
   (element (formula ХлоридНатрия) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   (element (formula Электролиз) (mass ?m2))
   =>
   (assert (element (formula ХлоратНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7180765))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7180765))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7180765))))
   (assert (appendmessagehalt (str-cat "NaCl (" ?m0 ") + H2O (" ?m1 ") + e (" ?m2 ") -(0.7180765)> NaClO3 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7180765) ") + NaCl (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7180765) ") + H2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7180765) ")")))
)


(defrule Барий_ДигидрогенаМонооксид_ГидроксидБария_Водород
   (declare (salience 40))
   (element (formula Барий) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.731027))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 2) 0.731027))))
   (assert (appendmessagehalt (str-cat "Ba (" ?m0 ") + H2O (" ?m1 ") -(0.731027)> Ba(OH)2 (" (* (/ (+ ?m0 ?m1) 2) 0.731027) ") + H2 (" (* (/ (+ ?m0 ?m1) 2) 0.731027) ")")))
)


(defrule ОксидБария_ДигидрогенаМонооксид_ГидроксидБария
   (declare (salience 40))
   (element (formula ОксидБария) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидБария) (mass (* (/ (+ ?m0 ?m1) 1) 0.363145))))
   (assert (appendmessagehalt (str-cat "BaO (" ?m0 ") + H2O (" ?m1 ") -(0.363145)> Ba(OH)2 (" (* (/ (+ ?m0 ?m1) 1) 0.363145) ")")))
)


(defrule СульфидБария_ДигидрогенаМонооксид_ГидроксидБария_Сероводород
   (declare (salience 40))
   (element (formula СульфидБария) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.9384171))))
   (assert (element (formula Сероводород) (mass (* (/ (+ ?m0 ?m1) 2) 0.9384171))))
   (assert (appendmessagehalt (str-cat "BaS (" ?m0 ") + H2O (" ?m1 ") -(0.9384171)> Ba(OH)2 (" (* (/ (+ ?m0 ?m1) 2) 0.9384171) ") + H2S (" (* (/ (+ ?m0 ?m1) 2) 0.9384171) ")")))
)


(defrule ХлоратНатрия_Тепло_ПерхлоратНатрия_ХлоридНатрия
   (declare (salience 40))
   (element (formula ХлоратНатрия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ПерхлоратНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3757016))))
   (assert (element (formula ХлоридНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.3757016))))
   (assert (appendmessagehalt (str-cat "NaClO3 (" ?m0 ") + t (" ?m1 ") -(0.3757016)> NaClO4 (" (* (/ (+ ?m0 ?m1) 2) 0.3757016) ") + NaCl (" (* (/ (+ ?m0 ?m1) 2) 0.3757016) ")")))
)


(defrule ОксидМарганца_Хлор_ГидроксидКалия_ПерманганатКалия_ХлоридКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   (element (formula ГидроксидКалия) (mass ?m2))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8890248))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8890248))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8890248))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + Cl2 (" ?m1 ") + KOH (" ?m2 ") -(0.8890248)> KMnO4 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8890248) ") + KCl (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8890248) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8890248) ")")))
)


(defrule ПерманганатКалия_Хлор_ПерманганатКалия_ХлоридКалия
   (declare (salience 40))
   (element (formula ПерманганатКалия) (mass ?m0))
   (element (formula Хлор) (mass ?m1))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.5416206))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.5416206))))
   (assert (appendmessagehalt (str-cat "K2MnO4 (" ?m0 ") + Cl2 (" ?m1 ") -(0.5416206)> KMnO4 (" (* (/ (+ ?m0 ?m1) 2) 0.5416206) ") + KCl (" (* (/ (+ ?m0 ?m1) 2) 0.5416206) ")")))
)


(defrule ПерманганатКалия_ДигидрогенаМонооксид_ПерманганатКалия_ОксидМарганца_ГидроксидКалия_Водород
   (declare (salience 40))
   (element (formula ПерманганатКалия) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1) 4) 0.8822575))))
   (assert (element (formula ОксидМарганца) (mass (* (/ (+ ?m0 ?m1) 4) 0.8822575))))
   (assert (element (formula ГидроксидКалия) (mass (* (/ (+ ?m0 ?m1) 4) 0.8822575))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1) 4) 0.8822575))))
   (assert (appendmessagehalt (str-cat "K2MnO4 (" ?m0 ") + H2O (" ?m1 ") -(0.8822575)> KMnO4 (" (* (/ (+ ?m0 ?m1) 4) 0.8822575) ") + MnO2 (" (* (/ (+ ?m0 ?m1) 4) 0.8822575) ") + KOH (" (* (/ (+ ?m0 ?m1) 4) 0.8822575) ") + H2 (" (* (/ (+ ?m0 ?m1) 4) 0.8822575) ")")))
)


(defrule КарбонатКальция_Тепло_ОксидКальция_УглекислыйГаз
   (declare (salience 40))
   (element (formula КарбонатКальция) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.8064108))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.8064108))))
   (assert (appendmessagehalt (str-cat "CaCO3 (" ?m0 ") + t (" ?m1 ") -(0.8064108)> CaO (" (* (/ (+ ?m0 ?m1) 2) 0.8064108) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.8064108) ")")))
)


(defrule Кальций_Кислород_ОксидКальция
   (declare (salience 40))
   (element (formula Кальций) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   =>
   (assert (element (formula ОксидКальция) (mass (* (/ (+ ?m0 ?m1) 1) 0.4644389))))
   (assert (appendmessagehalt (str-cat "Ca (" ?m0 ") + O2 (" ?m1 ") -(0.4644389)> CaO (" (* (/ (+ ?m0 ?m1) 1) 0.4644389) ")")))
)


(defrule НитратКальция_Тепло_ОксидКальция_ОксидАзота4_Кислород
   (declare (salience 40))
   (element (formula НитратКальция) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидКальция) (mass (* (/ (+ ?m0 ?m1) 3) 0.6848614))))
   (assert (element (formula ОксидАзота4) (mass (* (/ (+ ?m0 ?m1) 3) 0.6848614))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 3) 0.6848614))))
   (assert (appendmessagehalt (str-cat "Ca(NO3)2 (" ?m0 ") + t (" ?m1 ") -(0.6848614)> CaO (" (* (/ (+ ?m0 ?m1) 3) 0.6848614) ") + NO2 (" (* (/ (+ ?m0 ?m1) 3) 0.6848614) ") + O2 (" (* (/ (+ ?m0 ?m1) 3) 0.6848614) ")")))
)


(defrule ОксидКремния_Марганец_Тепло_ОксидМарганца_Кремний
   (declare (salience 40))
   (element (formula ОксидКремния) (mass ?m0))
   (element (formula Марганец) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидМарганца) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.4597094))))
   (assert (element (formula Кремний) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.4597094))))
   (assert (appendmessagehalt (str-cat "SiO2 (" ?m0 ") + Mn (" ?m1 ") + t (" ?m2 ") -(0.4597094)> MnO (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.4597094) ") + Si (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.4597094) ")")))
)


(defrule ХлоридРтути_Сероводород_Кордероит_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридРтути) (mass ?m0))
   (element (formula Сероводород) (mass ?m1))
   =>
   (assert (element (formula Кордероит) (mass (* (/ (+ ?m0 ?m1) 2) 0.839502))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.839502))))
   (assert (appendmessagehalt (str-cat "HgCl2 (" ?m0 ") + H2S (" ?m1 ") -(0.839502)> Hg3S2Cl2 (" (* (/ (+ ?m0 ?m1) 2) 0.839502) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.839502) ")")))
)


(defrule Кордероит_Сероводород_СульфидРтути_СолянаяКислота
   (declare (salience 40))
   (element (formula Кордероит) (mass ?m0))
   (element (formula Сероводород) (mass ?m1))
   =>
   (assert (element (formula СульфидРтути) (mass (* (/ (+ ?m0 ?m1) 2) 0.3592224))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.3592224))))
   (assert (appendmessagehalt (str-cat "Hg3S2Cl2 (" ?m0 ") + H2S (" ?m1 ") -(0.3592224)> HgS (" (* (/ (+ ?m0 ?m1) 2) 0.3592224) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.3592224) ")")))
)


(defrule СульфатБария_Углерод_СульфидБария_УгарныйГаз
   (declare (salience 40))
   (element (formula СульфатБария) (mass ?m0))
   (element (formula Углерод) (mass ?m1))
   =>
   (assert (element (formula СульфидБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.7425391))))
   (assert (element (formula УгарныйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.7425391))))
   (assert (appendmessagehalt (str-cat "BaSO4 (" ?m0 ") + C (" ?m1 ") -(0.7425391)> BaS (" (* (/ (+ ?m0 ?m1) 2) 0.7425391) ") + CO (" (* (/ (+ ?m0 ?m1) 2) 0.7425391) ")")))
)


(defrule ГидроксидБария_Сероводород_СульфидБария_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидБария) (mass ?m0))
   (element (formula Сероводород) (mass ?m1))
   =>
   (assert (element (formula СульфидБария) (mass (* (/ (+ ?m0 ?m1) 2) 0.397617))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.397617))))
   (assert (appendmessagehalt (str-cat "Ba(OH)2 (" ?m0 ") + H2S (" ?m1 ") -(0.397617)> BaS (" (* (/ (+ ?m0 ?m1) 2) 0.397617) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.397617) ")")))
)


(defrule ОксидМарганца_ГидроксидКалия_НитратКалия_Тепло_ПерманганатКалия_НитритКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula ГидроксидКалия) (mass ?m1))
   (element (formula НитратКалия) (mass ?m2))
   (element (formula Тепло) (mass ?m3))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.9236407))))
   (assert (element (formula НитритКалия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.9236407))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.9236407))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + KOH (" ?m1 ") + KNO3 (" ?m2 ") + t (" ?m3 ") -(0.9236407)> K2MnO4 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.9236407) ") + KNO2 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.9236407) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.9236407) ")")))
)


(defrule ОксидМарганца_КарбонатКалия_ХлоратКалия_Тепло_ПерманганатКалия_ХлоридКалия_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula КарбонатКалия) (mass ?m1))
   (element (formula ХлоратКалия) (mass ?m2))
   (element (formula Тепло) (mass ?m3))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.7739546))))
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.7739546))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.7739546))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + K2CO3 (" ?m1 ") + KClO3 (" ?m2 ") + t (" ?m3 ") -(0.7739546)> K2MnO4 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.7739546) ") + KCl (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.7739546) ") + CO2 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.7739546) ")")))
)


(defrule ОксидМарганца_ГидроксидКалия_Кислород_Тепло_ПерманганатКалия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula ГидроксидКалия) (mass ?m1))
   (element (formula Кислород) (mass ?m2))
   (element (formula Тепло) (mass ?m3))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.7893392))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.7893392))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + KOH (" ?m1 ") + O2 (" ?m2 ") + t (" ?m3 ") -(0.7893392)> K2MnO4 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.7893392) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 2) 0.7893392) ")")))
)


(defrule ПерманганатКалия_Тепло_ПерманганатКалия_ОксидМарганца_Кислород
   (declare (salience 40))
   (element (formula ПерманганатКалия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1) 3) 0.5786104))))
   (assert (element (formula ОксидМарганца) (mass (* (/ (+ ?m0 ?m1) 3) 0.5786104))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 3) 0.5786104))))
   (assert (appendmessagehalt (str-cat "KMnO4 (" ?m0 ") + t (" ?m1 ") -(0.5786104)> K2MnO4 (" (* (/ (+ ?m0 ?m1) 3) 0.5786104) ") + MnO2 (" (* (/ (+ ?m0 ?m1) 3) 0.5786104) ") + O2 (" (* (/ (+ ?m0 ?m1) 3) 0.5786104) ")")))
)


(defrule ОксидМарганца_ПероксидКалия_Тепло_ПерманганатКалия
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula ПероксидКалия) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ПерманганатКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 1) 0.5112388))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + K2O2 (" ?m1 ") + t (" ?m2 ") -(0.5112388)> K2MnO4 (" (* (/ (+ ?m0 ?m1 ?m2) 1) 0.5112388) ")")))
)


(defrule КарбонатКальция_АзотнаяКислота_НитратКальция_УглекислыйГаз_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula КарбонатКальция) (mass ?m0))
   (element (formula АзотнаяКислота) (mass ?m1))
   =>
   (assert (element (formula НитратКальция) (mass (* (/ (+ ?m0 ?m1) 3) 0.9217196))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 3) 0.9217196))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.9217196))))
   (assert (appendmessagehalt (str-cat "CaCO3 (" ?m0 ") + HNO3 (" ?m1 ") -(0.9217196)> Ca(NO3)2 (" (* (/ (+ ?m0 ?m1) 3) 0.9217196) ") + CO2 (" (* (/ (+ ?m0 ?m1) 3) 0.9217196) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.9217196) ")")))
)


(defrule НитратКальция_Тепло_ОксидКальция_ОксидАзота4_Кислород
   (declare (salience 40))
   (element (formula НитратКальция) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидКальция) (mass (* (/ (+ ?m0 ?m1) 3) 0.819558))))
   (assert (element (formula ОксидАзота4) (mass (* (/ (+ ?m0 ?m1) 3) 0.819558))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 3) 0.819558))))
   (assert (appendmessagehalt (str-cat "Ca(NO3)2 (" ?m0 ") + t (" ?m1 ") -(0.819558)> CaO (" (* (/ (+ ?m0 ?m1) 3) 0.819558) ") + NO2 (" (* (/ (+ ?m0 ?m1) 3) 0.819558) ") + O2 (" (* (/ (+ ?m0 ?m1) 3) 0.819558) ")")))
)


(defrule Кальций_АзотнаяКислота_НитратКальция_ОксидАзота1_ОксидАзота2_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Кальций) (mass ?m0))
   (element (formula АзотнаяКислота) (mass ?m1))
   =>
   (assert (element (formula НитратКальция) (mass (* (/ (+ ?m0 ?m1) 4) 0.7829475))))
   (assert (element (formula ОксидАзота1) (mass (* (/ (+ ?m0 ?m1) 4) 0.7829475))))
   (assert (element (formula ОксидАзота2) (mass (* (/ (+ ?m0 ?m1) 4) 0.7829475))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 4) 0.7829475))))
   (assert (appendmessagehalt (str-cat "Ca (" ?m0 ") + HNO3 (" ?m1 ") -(0.7829475)> Ca(NO3)2 (" (* (/ (+ ?m0 ?m1) 4) 0.7829475) ") + N2O (" (* (/ (+ ?m0 ?m1) 4) 0.7829475) ") + NO (" (* (/ (+ ?m0 ?m1) 4) 0.7829475) ") + H2O (" (* (/ (+ ?m0 ?m1) 4) 0.7829475) ")")))
)


(defrule ОксидКальция_АзотнаяКислота_НитратКальция_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидКальция) (mass ?m0))
   (element (formula АзотнаяКислота) (mass ?m1))
   =>
   (assert (element (formula НитратКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.4757425))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.4757425))))
   (assert (appendmessagehalt (str-cat "CaO (" ?m0 ") + HNO3 (" ?m1 ") -(0.4757425)> Ca(NO3)2 (" (* (/ (+ ?m0 ?m1) 2) 0.4757425) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.4757425) ")")))
)


(defrule ГидроксидКальция_ОксидАзота4_НитратКальция_НитритКальция_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидКальция) (mass ?m0))
   (element (formula ОксидАзота4) (mass ?m1))
   =>
   (assert (element (formula НитратКальция) (mass (* (/ (+ ?m0 ?m1) 3) 0.4280505))))
   (assert (element (formula НитритКальция) (mass (* (/ (+ ?m0 ?m1) 3) 0.4280505))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.4280505))))
   (assert (appendmessagehalt (str-cat "Ca(OH)2 (" ?m0 ") + NO2 (" ?m1 ") -(0.4280505)> Ca(NO3)2 (" (* (/ (+ ?m0 ?m1) 3) 0.4280505) ") + Ca(NO2)2 (" (* (/ (+ ?m0 ?m1) 3) 0.4280505) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.4280505) ")")))
)


(defrule СульфидКальция_АзотнаяКислота_НитратКальция_Сера_ОксидАзота4_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СульфидКальция) (mass ?m0))
   (element (formula АзотнаяКислота) (mass ?m1))
   =>
   (assert (element (formula НитратКальция) (mass (* (/ (+ ?m0 ?m1) 4) 0.5904143))))
   (assert (element (formula Сера) (mass (* (/ (+ ?m0 ?m1) 4) 0.5904143))))
   (assert (element (formula ОксидАзота4) (mass (* (/ (+ ?m0 ?m1) 4) 0.5904143))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 4) 0.5904143))))
   (assert (appendmessagehalt (str-cat "CaS (" ?m0 ") + HNO3 (" ?m1 ") -(0.5904143)> Ca(NO3)2 (" (* (/ (+ ?m0 ?m1) 4) 0.5904143) ") + S (" (* (/ (+ ?m0 ?m1) 4) 0.5904143) ") + NO2 (" (* (/ (+ ?m0 ?m1) 4) 0.5904143) ") + H2O (" (* (/ (+ ?m0 ?m1) 4) 0.5904143) ")")))
)


(defrule ОксидМарганца_Тепло_ОксидМарганца
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидМарганца) (mass (* (/ (+ ?m0 ?m1) 1) 0.8143638))))
   (assert (appendmessagehalt (str-cat "MnO2 (" ?m0 ") + t (" ?m1 ") -(0.8143638)> Mn2O3 (" (* (/ (+ ?m0 ?m1) 1) 0.8143638) ")")))
)


(defrule ОксидМарганца_Алюминий_Тепло_Марганец_ОксидАлюминия_Тепло
   (declare (salience 40))
   (element (formula ОксидМарганца) (mass ?m0))
   (element (formula Алюминий) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Марганец) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8755214))))
   (assert (element (formula ОксидАлюминия) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8755214))))
   (assert (element (formula Тепло) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8755214))))
   (assert (appendmessagehalt (str-cat "Mn2O3 (" ?m0 ") + Al (" ?m1 ") + t (" ?m2 ") -(0.8755214)> Mn (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8755214) ") + Al2O3 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8755214) ") + t (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.8755214) ")")))
)


(defrule СульфидРтути_ХлоридРтути_Тепло_Кордероит
   (declare (salience 40))
   (element (formula СульфидРтути) (mass ?m0))
   (element (formula ХлоридРтути) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Кордероит) (mass (* (/ (+ ?m0 ?m1 ?m2) 1) 0.48884))))
   (assert (appendmessagehalt (str-cat "HgS (" ?m0 ") + HgCl2 (" ?m1 ") + t (" ?m2 ") -(0.48884)> Hg3S2Cl2 (" (* (/ (+ ?m0 ?m1 ?m2) 1) 0.48884) ")")))
)


(defrule СульфидЖелеза_СолянаяКислота_Сероводород_ХлоридЖелеза
   (declare (salience 40))
   (element (formula СульфидЖелеза) (mass ?m0))
   (element (formula СолянаяКислота) (mass ?m1))
   =>
   (assert (element (formula Сероводород) (mass (* (/ (+ ?m0 ?m1) 2) 0.7131879))))
   (assert (element (formula ХлоридЖелеза) (mass (* (/ (+ ?m0 ?m1) 2) 0.7131879))))
   (assert (appendmessagehalt (str-cat "FeS (" ?m0 ") + HCl (" ?m1 ") -(0.7131879)> H2S (" (* (/ (+ ?m0 ?m1) 2) 0.7131879) ") + FeCl2 (" (* (/ (+ ?m0 ?m1) 2) 0.7131879) ")")))
)


(defrule СульфидАлюминия_ДигидрогенаМонооксид_Сероводород_ГидроксидАлюминия
   (declare (salience 40))
   (element (formula СульфидАлюминия) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula Сероводород) (mass (* (/ (+ ?m0 ?m1) 2) 0.4856688))))
   (assert (element (formula ГидроксидАлюминия) (mass (* (/ (+ ?m0 ?m1) 2) 0.4856688))))
   (assert (appendmessagehalt (str-cat "Al2S3 (" ?m0 ") + H2O (" ?m1 ") -(0.4856688)> H2S (" (* (/ (+ ?m0 ?m1) 2) 0.4856688) ") + Al(OH)3 (" (* (/ (+ ?m0 ?m1) 2) 0.4856688) ")")))
)


(defrule НитратКальция_КарбонатКалия_НитратКалия_КарбонатКальция
   (declare (salience 40))
   (element (formula НитратКальция) (mass ?m0))
   (element (formula КарбонатКалия) (mass ?m1))
   =>
   (assert (element (formula НитратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.5258185))))
   (assert (element (formula КарбонатКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.5258185))))
   (assert (appendmessagehalt (str-cat "Ca(NO3)2 (" ?m0 ") + K2CO3 (" ?m1 ") -(0.5258185)> KNO3 (" (* (/ (+ ?m0 ?m1) 2) 0.5258185) ") + CaCO3 (" (* (/ (+ ?m0 ?m1) 2) 0.5258185) ")")))
)


(defrule НитратКальция_СульфатКалия_НитратКалия_СульфатКальция
   (declare (salience 40))
   (element (formula НитратКальция) (mass ?m0))
   (element (formula СульфатКалия) (mass ?m1))
   =>
   (assert (element (formula НитратКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.7296854))))
   (assert (element (formula СульфатКальция) (mass (* (/ (+ ?m0 ?m1) 2) 0.7296854))))
   (assert (appendmessagehalt (str-cat "Ca(NO3)2 (" ?m0 ") + K2SO4 (" ?m1 ") -(0.7296854)> KNO3 (" (* (/ (+ ?m0 ?m1) 2) 0.7296854) ") + CaSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.7296854) ")")))
)


(defrule Калий_Кислород_Холод_ПероксидКалия
   (declare (salience 40))
   (element (formula Калий) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Холод) (mass ?m2))
   =>
   (assert (element (formula ПероксидКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 1) 0.3551377))))
   (assert (appendmessagehalt (str-cat "K (" ?m0 ") + O2 (" ?m1 ") + not_t (" ?m2 ") -(0.3551377)> K2O2 (" (* (/ (+ ?m0 ?m1 ?m2) 1) 0.3551377) ")")))
)


(defrule ОксидКальция_Тепло_ПероксидКалия_Кислород
   (declare (salience 40))
   (element (formula ОксидКальция) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ПероксидКалия) (mass (* (/ (+ ?m0 ?m1) 2) 0.6483526))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 2) 0.6483526))))
   (assert (appendmessagehalt (str-cat "KO2 (" ?m0 ") + t (" ?m1 ") -(0.6483526)> K2O2 (" (* (/ (+ ?m0 ?m1) 2) 0.6483526) ") + O2 (" (* (/ (+ ?m0 ?m1) 2) 0.6483526) ")")))
)


(defrule ОксидАлюминия_Электролиз_Тепло_Криолит_Алюминий_Кислород_Криолит
   (declare (salience 40))
   (element (formula ОксидАлюминия) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   (element (formula Криолит) (mass ?m3))
   =>
   (assert (element (formula Алюминий) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.9350983))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.9350983))))
   (assert (element (formula Криолит) (mass (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.9350983))))
   (assert (appendmessagehalt (str-cat "Al2O3 (" ?m0 ") + e (" ?m1 ") + t (" ?m2 ") + Na3AlF6 (" ?m3 ") -(0.9350983)> Al (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.9350983) ") + O2 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.9350983) ") + Na3AlF6 (" (* (/ (+ ?m0 ?m1 ?m2 ?m3) 3) 0.9350983) ")")))
)


(defrule ХлоридАлюминия_Калий_Тепло_ХлоридКалия_Алюминий
   (declare (salience 40))
   (element (formula ХлоридАлюминия) (mass ?m0))
   (element (formula Калий) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ХлоридКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.8115379))))
   (assert (element (formula Алюминий) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.8115379))))
   (assert (appendmessagehalt (str-cat "AlCl3 (" ?m0 ") + K (" ?m1 ") + t (" ?m2 ") -(0.8115379)> KCl (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.8115379) ") + Al (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.8115379) ")")))
)


(defrule Железо_Сера_СульфидЖелеза
   (declare (salience 40))
   (element (formula Железо) (mass ?m0))
   (element (formula Сера) (mass ?m1))
   =>
   (assert (element (formula СульфидЖелеза) (mass (* (/ (+ ?m0 ?m1) 1) 0.7574723))))
   (assert (appendmessagehalt (str-cat "Fe (" ?m0 ") + S (" ?m1 ") -(0.7574723)> FeS (" (* (/ (+ ?m0 ?m1) 1) 0.7574723) ")")))
)


(defrule СульфидЖелеза_Тепло_СульфидЖелеза
   (declare (salience 40))
   (element (formula СульфидЖелеза) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula СульфидЖелеза) (mass (* (/ (+ ?m0 ?m1) 1) 0.4802141))))
   (assert (appendmessagehalt (str-cat "FeS2 (" ?m0 ") + t (" ?m1 ") -(0.4802141)> FeS (" (* (/ (+ ?m0 ?m1) 1) 0.4802141) ")")))
)


(defrule ОксидЖелеза3_Водород_Сероводород_СульфидЖелеза_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидЖелеза3) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   (element (formula Сероводород) (mass ?m2))
   =>
   (assert (element (formula СульфидЖелеза) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.5228826))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.5228826))))
   (assert (appendmessagehalt (str-cat "Fe2O3 (" ?m0 ") + H2 (" ?m1 ") + H2S (" ?m2 ") -(0.5228826)> FeS (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.5228826) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.5228826) ")")))
)


(defrule Алюминий_Сера_Тепло_СульфидАлюминия
   (declare (salience 40))
   (element (formula Алюминий) (mass ?m0))
   (element (formula Сера) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula СульфидАлюминия) (mass (* (/ (+ ?m0 ?m1 ?m2) 1) 0.67435))))
   (assert (appendmessagehalt (str-cat "Al (" ?m0 ") + S (" ?m1 ") + t (" ?m2 ") -(0.67435)> Al2S3 (" (* (/ (+ ?m0 ?m1 ?m2) 1) 0.67435) ")")))
)


(defrule Натрий_ГидроксидКалия_ГидроксидНатрия_Калий
   (declare (salience 40))
   (element (formula Натрий) (mass ?m0))
   (element (formula ГидроксидКалия) (mass ?m1))
   =>
   (assert (element (formula ГидроксидНатрия) (mass (* (/ (+ ?m0 ?m1) 2) 0.8872477))))
   (assert (element (formula Калий) (mass (* (/ (+ ?m0 ?m1) 2) 0.8872477))))
   (assert (appendmessagehalt (str-cat "Na (" ?m0 ") + KOH (" ?m1 ") -(0.8872477)> NaOH (" (* (/ (+ ?m0 ?m1) 2) 0.8872477) ") + K (" (* (/ (+ ?m0 ?m1) 2) 0.8872477) ")")))
)


(defrule ОксидМеди_Алюминий_Тепло_ОксидАлюминия_Медь
   (declare (salience 40))
   (element (formula ОксидМеди) (mass ?m0))
   (element (formula Алюминий) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидАлюминия) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.6712757))))
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.6712757))))
   (assert (appendmessagehalt (str-cat "Cu2O (" ?m0 ") + Al (" ?m1 ") + t (" ?m2 ") -(0.6712757)> Al2O3 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.6712757) ") + Cu (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.6712757) ")")))
)


(defrule ГидроксидАлюминия_Тепло_ОксидАлюминия_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ГидроксидАлюминия) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидАлюминия) (mass (* (/ (+ ?m0 ?m1) 2) 0.304862))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.304862))))
   (assert (appendmessagehalt (str-cat "Al(OH)3 (" ?m0 ") + t (" ?m1 ") -(0.304862)> Al2O3 (" (* (/ (+ ?m0 ?m1) 2) 0.304862) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.304862) ")")))
)


(defrule ОксидЖелеза3_Водород_Тепло_Железо_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидЖелеза3) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Железо) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.3113468))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.3113468))))
   (assert (appendmessagehalt (str-cat "Fe2O3 (" ?m0 ") + H2 (" ?m1 ") + t (" ?m2 ") -(0.3113468)> Fe (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.3113468) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.3113468) ")")))
)


(defrule ОксидЖелеза3_УгарныйГаз_Железо_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидЖелеза3) (mass ?m0))
   (element (formula УгарныйГаз) (mass ?m1))
   =>
   (assert (element (formula Железо) (mass (* (/ (+ ?m0 ?m1) 2) 0.4092123))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.4092123))))
   (assert (appendmessagehalt (str-cat "Fe2O3 (" ?m0 ") + CO (" ?m1 ") -(0.4092123)> Fe (" (* (/ (+ ?m0 ?m1) 2) 0.4092123) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.4092123) ")")))
)


(defrule ОксидЖелеза_УгарныйГаз_Железо_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидЖелеза) (mass ?m0))
   (element (formula УгарныйГаз) (mass ?m1))
   =>
   (assert (element (formula Железо) (mass (* (/ (+ ?m0 ?m1) 2) 0.3023431))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.3023431))))
   (assert (appendmessagehalt (str-cat "FeO (" ?m0 ") + CO (" ?m1 ") -(0.3023431)> Fe (" (* (/ (+ ?m0 ?m1) 2) 0.3023431) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.3023431) ")")))
)


(defrule ОксидЖелеза_УгарныйГаз_Железо_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидЖелеза) (mass ?m0))
   (element (formula УгарныйГаз) (mass ?m1))
   =>
   (assert (element (formula Железо) (mass (* (/ (+ ?m0 ?m1) 2) 0.5178273))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.5178273))))
   (assert (appendmessagehalt (str-cat "FeO (" ?m0 ") + CO (" ?m1 ") -(0.5178273)> Fe (" (* (/ (+ ?m0 ?m1) 2) 0.5178273) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.5178273) ")")))
)


(defrule ОксидЖелеза3_Алюминий_Железо_ОксидАлюминия
   (declare (salience 40))
   (element (formula ОксидЖелеза3) (mass ?m0))
   (element (formula Алюминий) (mass ?m1))
   =>
   (assert (element (formula Железо) (mass (* (/ (+ ?m0 ?m1) 2) 0.8208658))))
   (assert (element (formula ОксидАлюминия) (mass (* (/ (+ ?m0 ?m1) 2) 0.8208658))))
   (assert (appendmessagehalt (str-cat "Fe2O3 (" ?m0 ") + Al (" ?m1 ") -(0.8208658)> Fe (" (* (/ (+ ?m0 ?m1) 2) 0.8208658) ") + Al2O3 (" (* (/ (+ ?m0 ?m1) 2) 0.8208658) ")")))
)


(defrule Медь_Кислород_Тепло_ОксидМеди2_ОксидМеди
   (declare (salience 40))
   (element (formula Медь) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидМеди2) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.4149798))))
   (assert (element (formula ОксидМеди) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.4149798))))
   (assert (appendmessagehalt (str-cat "Cu (" ?m0 ") + O2 (" ?m1 ") + t (" ?m2 ") -(0.4149798)> CuO (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.4149798) ") + Cu2O (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.4149798) ")")))
)


(defrule Медь_ОксидАзота1_Тепло_ОксидМеди_Азот
   (declare (salience 40))
   (element (formula Медь) (mass ?m0))
   (element (formula ОксидАзота1) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula ОксидМеди) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.3851685))))
   (assert (element (formula Азот) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.3851685))))
   (assert (appendmessagehalt (str-cat "Cu (" ?m0 ") + N2O (" ?m1 ") + t (" ?m2 ") -(0.3851685)> Cu2O (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.3851685) ") + N2 (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.3851685) ")")))
)


(defrule ОксидМеди2_Углерод_Медь_УглекислыйГаз
   (declare (salience 40))
   (element (formula ОксидМеди2) (mass ?m0))
   (element (formula Углерод) (mass ?m1))
   =>
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1) 2) 0.6903064))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 2) 0.6903064))))
   (assert (appendmessagehalt (str-cat "CuO (" ?m0 ") + C (" ?m1 ") -(0.6903064)> Cu (" (* (/ (+ ?m0 ?m1) 2) 0.6903064) ") + CO2 (" (* (/ (+ ?m0 ?m1) 2) 0.6903064) ")")))
)


(defrule ОксидМеди2_Водород_Медь_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula ОксидМеди2) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   =>
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1) 2) 0.5108845))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 2) 0.5108845))))
   (assert (appendmessagehalt (str-cat "CuO (" ?m0 ") + H2 (" ?m1 ") -(0.5108845)> Cu (" (* (/ (+ ?m0 ?m1) 2) 0.5108845) ") + H2O (" (* (/ (+ ?m0 ?m1) 2) 0.5108845) ")")))
)


(defrule Малахит_Тепло_ОксидМеди2_УглекислыйГаз_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Малахит) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula ОксидМеди2) (mass (* (/ (+ ?m0 ?m1) 3) 0.6696604))))
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1) 3) 0.6696604))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.6696604))))
   (assert (appendmessagehalt (str-cat "(CuOH)2CO3 (" ?m0 ") + t (" ?m1 ") -(0.6696604)> CuO (" (* (/ (+ ?m0 ?m1) 3) 0.6696604) ") + CO2 (" (* (/ (+ ?m0 ?m1) 3) 0.6696604) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.6696604) ")")))
)


(defrule Малахит_УгарныйГаз_Тепло_УглекислыйГаз_Медь_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula Малахит) (mass ?m0))
   (element (formula УгарныйГаз) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula УглекислыйГаз) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7463569))))
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7463569))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7463569))))
   (assert (appendmessagehalt (str-cat "(CuOH)2CO3 (" ?m0 ") + CO (" ?m1 ") + t (" ?m2 ") -(0.7463569)> CO2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7463569) ") + Cu (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7463569) ") + H2O (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.7463569) ")")))
)


(defrule ХлоридБария_Электролиз_Барий_Хлор
   (declare (salience 40))
   (element (formula ХлоридБария) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   =>
   (assert (element (formula Барий) (mass (* (/ (+ ?m0 ?m1) 2) 0.861469))))
   (assert (element (formula Хлор) (mass (* (/ (+ ?m0 ?m1) 2) 0.861469))))
   (assert (appendmessagehalt (str-cat "BaCl2 (" ?m0 ") + e (" ?m1 ") -(0.861469)> Ba (" (* (/ (+ ?m0 ?m1) 2) 0.861469) ") + Cl2 (" (* (/ (+ ?m0 ?m1) 2) 0.861469) ")")))
)


(defrule СолянаяКислота_ОксидМарганца_Хлор_ХлоридМарганца_ДигидрогенаМонооксид
   (declare (salience 40))
   (element (formula СолянаяКислота) (mass ?m0))
   (element (formula ОксидМарганца) (mass ?m1))
   =>
   (assert (element (formula Хлор) (mass (* (/ (+ ?m0 ?m1) 3) 0.5301975))))
   (assert (element (formula ХлоридМарганца) (mass (* (/ (+ ?m0 ?m1) 3) 0.5301975))))
   (assert (element (formula ДигидрогенаМонооксид) (mass (* (/ (+ ?m0 ?m1) 3) 0.5301975))))
   (assert (appendmessagehalt (str-cat "HCl (" ?m0 ") + MnO2 (" ?m1 ") -(0.5301975)> Cl2 (" (* (/ (+ ?m0 ?m1) 3) 0.5301975) ") + MnCl2 (" (* (/ (+ ?m0 ?m1) 3) 0.5301975) ") + H2O (" (* (/ (+ ?m0 ?m1) 3) 0.5301975) ")")))
)


(defrule ХлоридНатрия_Электролиз_Натрий_Хлор
   (declare (salience 40))
   (element (formula ХлоридНатрия) (mass ?m0))
   (element (formula Электролиз) (mass ?m1))
   =>
   (assert (element (formula Натрий) (mass (* (/ (+ ?m0 ?m1) 2) 0.7626747))))
   (assert (element (formula Хлор) (mass (* (/ (+ ?m0 ?m1) 2) 0.7626747))))
   (assert (appendmessagehalt (str-cat "NaCl (" ?m0 ") + e (" ?m1 ") -(0.7626747)> Na (" (* (/ (+ ?m0 ?m1) 2) 0.7626747) ") + Cl2 (" (* (/ (+ ?m0 ?m1) 2) 0.7626747) ")")))
)


(defrule ХлоридКалия_ДигидрогенаМонооксид_Электролиз_ГидроксидКалия_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридКалия) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   (element (formula Электролиз) (mass ?m2))
   =>
   (assert (element (formula ГидроксидКалия) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.897651))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.897651))))
   (assert (appendmessagehalt (str-cat "KCl (" ?m0 ") + H2O (" ?m1 ") + e (" ?m2 ") -(0.897651)> KOH (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.897651) ") + HCl (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.897651) ")")))
)


(defrule Халькопирит_Кислород_Тепло_СульфидМеди_ОксидЖелеза
   (declare (salience 40))
   (element (formula Халькопирит) (mass ?m0))
   (element (formula Кислород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula СульфидМеди) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.5986105))))
   (assert (element (formula ОксидЖелеза) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.5986105))))
   (assert (appendmessagehalt (str-cat "CuFeS2 (" ?m0 ") + O2 (" ?m1 ") + t (" ?m2 ") -(0.5986105)> Cu2S (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.5986105) ") + FeO (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.5986105) ")")))
)


(defrule СульфидМеди_ДигидрогенаМонооксид_Тепло_Медь_ДиоксидСеры_Водород
   (declare (salience 40))
   (element (formula СульфидМеди) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6772568))))
   (assert (element (formula ДиоксидСеры) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6772568))))
   (assert (element (formula Водород) (mass (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6772568))))
   (assert (appendmessagehalt (str-cat "Cu2S (" ?m0 ") + H2O (" ?m1 ") + t (" ?m2 ") -(0.6772568)> Cu (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6772568) ") + SO2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6772568) ") + H2 (" (* (/ (+ ?m0 ?m1 ?m2) 3) 0.6772568) ")")))
)


(defrule СульфидМеди_Тепло_Медь_Сера
   (declare (salience 40))
   (element (formula СульфидМеди) (mass ?m0))
   (element (formula Тепло) (mass ?m1))
   =>
   (assert (element (formula Медь) (mass (* (/ (+ ?m0 ?m1) 2) 0.3067362))))
   (assert (element (formula Сера) (mass (* (/ (+ ?m0 ?m1) 2) 0.3067362))))
   (assert (appendmessagehalt (str-cat "Cu2S (" ?m0 ") + t (" ?m1 ") -(0.3067362)> Cu (" (* (/ (+ ?m0 ?m1) 2) 0.3067362) ") + S (" (* (/ (+ ?m0 ?m1) 2) 0.3067362) ")")))
)


(defrule СульфидСвинца_СолянаяКислота_ХлоридСвинца_Сероводород
   (declare (salience 40))
   (element (formula СульфидСвинца) (mass ?m0))
   (element (formula СолянаяКислота) (mass ?m1))
   =>
   (assert (element (formula ХлоридСвинца) (mass (* (/ (+ ?m0 ?m1) 2) 0.6175708))))
   (assert (element (formula Сероводород) (mass (* (/ (+ ?m0 ?m1) 2) 0.6175708))))
   (assert (appendmessagehalt (str-cat "PbS (" ?m0 ") + HCl (" ?m1 ") -(0.6175708)> PbCl2 (" (* (/ (+ ?m0 ?m1) 2) 0.6175708) ") + H2S (" (* (/ (+ ?m0 ?m1) 2) 0.6175708) ")")))
)


(defrule СульфидСвинца_Водород_Тепло_Свинец_Сероводород
   (declare (salience 40))
   (element (formula СульфидСвинца) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Свинец) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.7012511))))
   (assert (element (formula Сероводород) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.7012511))))
   (assert (appendmessagehalt (str-cat "PbS (" ?m0 ") + H2 (" ?m1 ") + t (" ?m2 ") -(0.7012511)> Pb (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.7012511) ") + H2S (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.7012511) ")")))
)


(defrule СульфидСвинца_Озон_СульфатСвинца_Кислород
   (declare (salience 40))
   (element (formula СульфидСвинца) (mass ?m0))
   (element (formula Озон) (mass ?m1))
   =>
   (assert (element (formula СульфатСвинца) (mass (* (/ (+ ?m0 ?m1) 2) 0.4991926))))
   (assert (element (formula Кислород) (mass (* (/ (+ ?m0 ?m1) 2) 0.4991926))))
   (assert (appendmessagehalt (str-cat "PbS (" ?m0 ") + O3 (" ?m1 ") -(0.4991926)> PbSO4 (" (* (/ (+ ?m0 ?m1) 2) 0.4991926) ") + O2 (" (* (/ (+ ?m0 ?m1) 2) 0.4991926) ")")))
)


(defrule ХлоридСвинца_ДигидрогенаМонооксид_ГидроксидХлоридСвинца_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридСвинца) (mass ?m0))
   (element (formula ДигидрогенаМонооксид) (mass ?m1))
   =>
   (assert (element (formula ГидроксидХлоридСвинца) (mass (* (/ (+ ?m0 ?m1) 2) 0.8838909))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1) 2) 0.8838909))))
   (assert (appendmessagehalt (str-cat "PbCl2 (" ?m0 ") + H2O (" ?m1 ") -(0.8838909)> Pb(OH)Cl (" (* (/ (+ ?m0 ?m1) 2) 0.8838909) ") + HCl (" (* (/ (+ ?m0 ?m1) 2) 0.8838909) ")")))
)


(defrule ХлоридСвинца_Водород_Тепло_Свинец_СолянаяКислота
   (declare (salience 40))
   (element (formula ХлоридСвинца) (mass ?m0))
   (element (formula Водород) (mass ?m1))
   (element (formula Тепло) (mass ?m2))
   =>
   (assert (element (formula Свинец) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.4098166))))
   (assert (element (formula СолянаяКислота) (mass (* (/ (+ ?m0 ?m1 ?m2) 2) 0.4098166))))
   (assert (appendmessagehalt (str-cat "PbCl2 (" ?m0 ") + H2 (" ?m1 ") + t (" ?m2 ") -(0.4098166)> Pb (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.4098166) ") + HCl (" (* (/ (+ ?m0 ?m1 ?m2) 2) 0.4098166) ")")))
)