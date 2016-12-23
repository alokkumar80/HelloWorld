merge into D_ERM_IBV.ENCTR_STD_GRP_HIST std_grp
using
--select enctr_id,v_grp_cd from
WITH
--Discharge Date is not null AND Discharge Status TERM is null AND Total Account Balance = 0
TERM1 AS
(select eh.enctr_id,
    eh.eff_from_dt,
    eh.eff_thru_dt,
    COUNT(*) term1_cnt,
    'Exclude From Reports' v_grp_cd_1
from D_ERM_STG.STG_ENCTR_HIST eh --on (e.enctr_id = eh.enctr_id) /* will be D_ERM_IBV.ENCTR_HIST */ 
join D_ERM_IBV.ENCTR_AGG agg on(eh.enctr_id = agg.enctr_id and eh.rec_auth = agg.rec_auth)
join d_idw_ACCV.ENCTR_ADMSN ed on (ed.enctr_id = eh.enctr_id) --and eh.rec_auth = ed.rec_auth)
where ed.dschrg_dt_tm is not null 
and ed.dschrg_cd is null --ENCTR_ID = 308841659 --N/A|SRC|UB04-DISCH_LOC???
and to_date('2016-11-30','yyyy-mm-dd') between eh.eff_from_dt and eh.eff_thru_dt 
and agg.TOT_AR_BAL = 0 --Total Account Balance = 0
group by eh.enctr_id,
    eh.eff_from_dt,
    eh.eff_thru_dt)
select enctr_hist.enctr_id enctr_id,
case
WHEN TERM1.term1_cnt > 0 THEN TERM1.v_grp_cd_1
end v_grp_cd
from D_ERM_STG.STG_ENCTR_HIST enctr_hist
left outer join term1 on(enctr_hist.enctr_id = term1.enctr_id)
where to_date('2016-11-30','yyyy-mm-dd') BETWEEN enctr_hist.eff_from_dt AND enctr_hist.eff_thru_dt
and enctr_hist.enctr_id in(55194000089,100927700148,147980800091) 
;


--terms on(terms.enctr_id = std_grp.enctr_id);