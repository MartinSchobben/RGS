# Loading the respective dataset and alter ui based on availability

    Code
      input_ui("x")
    Output
      <div class="form-group shiny-input-container">
        <label class="control-label" id="x-dataset-label" for="x-dataset">
          <h5>Selecteer schema</h5>
        </label>
        <div>
          <select id="x-dataset"><option value="Nederland" selected>Nederland</option></select>
          <script type="application/json" data-for="x-dataset" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
        </div>
      </div>

# find terminal nodes

    Code
      terminator(ls_codes, 4)
    Output
      BIvaKouVvp BIvaKouAkp BIvaKouCae BIvaKouCuh BIvaKooVvp BIvaKooAkp BIvaKooCae 
            TRUE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BIvaKooCuh BIvaCevVvp BIvaCevAkp BIvaCevCae BIvaCevCuh BIvaGooVvp BIvaGooAkp 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BIvaGooCae BIvaGooCuh BIvaVoiVvp BIvaVoiAkp BIvaVoiCae BIvaVoiCuh BIvaBouVvp 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BIvaBouAkp BIvaBouCae BIvaBouCuh BIvaOivVvp BIvaOivAkp BIvaOivCae BIvaOivCuh 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BMvaTerVvp BMvaTerAkp BMvaTerCae BMvaTerCuh BMvaBegVvp BMvaBegAkp BMvaBegCae 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BMvaBegCuh BMvaVerVvp BMvaVerAkp BMvaVerCae BMvaVerCuh BMvaMeiVvp BMvaMeiAkp 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BMvaMeiCae BMvaMeiCuh BMvaObeVvp BMvaObeAkp BMvaObeCae BMvaObeCuh BMvaBeiVvp 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BMvaBeiAkp BMvaBeiCae BMvaBeiCuh BMvaTevVvp BMvaTevAkp BMvaTevCae BMvaTevCuh 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BMvaHuuVvp BMvaHuuAkp BMvaHuuCae BMvaHuuCuh BMvaVliVvp BMvaVliAkp BMvaVliCae 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BMvaVliCuh BMvaSchVvp BMvaSchAkp BMvaSchCae BMvaSchCuh BMvaMepVvp BMvaMepCae 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BMvaMepCuh BMvaGebVvp BMvaGebCae BMvaGebCuh BMvaVbiVvp BMvaVbiAkp BMvaVbiCae 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BMvaVbiCuh BMvaVmvVvp BMvaVmvAkp BMvaVmvCae BMvaVmvCuh BMvaNadVvp BMvaNadAkp 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BMvaNadCae BMvaNadCuh BMvaOrzVvp BMvaOrzAkp BMvaOrzCae BMvaOrzCuh BVasVioVvp 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BVasVioAkp BVasVioCae BVasVioCuh BVasSviVvp BVasSviAkp BVasSviCae BVasSviCuh 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BVasCviVvp BVasCviAkp BVasCviCae BVasCviCuh BVasOzvVvp BVasOzvAkp BVasOzvCae 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BVasOzvCuh BFvaDigNev BFvaDigCae BFvaDigCuh BFvaDioNev BFvaDioCae BFvaDioCuh 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BFvaVogVgl BFvaVogCae BFvaVogCuh BFvaVovVol BFvaVovCae BFvaVovCuh BFvaAndKpr 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BFvaAndCae BFvaAndCuh BFvaVopVpl BFvaVopCae BFvaVopCuh BFvaOveWaa BFvaOveCuw 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BFvaOveCuh BFvaOvrVob BFvaOvrVoa BFvaOvrVgb BFvaOvrVga BFvaOvrVoc BFvaOvrVca 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BFvaOvrVgc BFvaOvrVaw BFvaOvrLvl BFvaOvrLvc BFvaOvrHva BFvaOvrHvc BFvaOvrTsl 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BFvaOvrTsc BFvaOvrWaa BFvaOvrWac BFvaOvrLed BFvaOvrLec BFvaOvrOvl BFvaOvrOvc 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BFvaOvrSid BFvaOvrAga BFvaLbvBll BFvaLbvVtv BFvaLbvVtg BFvaSubSub BFvaSubSuc 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BFvaLenLen BFvaIlgIlg BFvaIlgAil BFvaIlgAvp BFvaNvmNvm BFvaNvmCae BFvaNvmCuh 
           FALSE      FALSE      FALSE       TRUE      FALSE      FALSE      FALSE 
      BVrdGehVoo BVrdGehTus BVrdGehVic BVrdGehHvv BVrdGehHvi BVrdHalVoo BVrdHalVic 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BVrdHalHvv BVrdOweVoo BVrdOweGet BVrdOweVzv BVrdGepVoo BVrdGepVic BVrdGepHvv 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BVrdHanVoo BVrdHanTus BVrdHanVic BVrdHanHvv BVrdVrvVoo BVrdVrvVic BVrdVrvHvv 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BVrdEmbVoo BVrdEmbVic BVrdEmbHvv BVrdVasVio BVrdVasVbv BVrdVasVic BVrdVasHvv 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BVrdNigVoo BVrdNigVic BVrdNigHvv BVrdVooVoo BProOnpGkn BProOnpOpo BProOnpOpv 
            TRUE       TRUE       TRUE       TRUE      FALSE       TRUE       TRUE 
      BProOnpGet BProOnpOpi BProOnpVzv BVorDebHad BVorDebHdi BVorDebVdd BVorDebHdb 
           FALSE       TRUE      FALSE       TRUE       TRUE       TRUE       TRUE 
      BVorDebTus BVorDebVhd BVorVogVr1 BVorVogVr2 BVorVogVr3 BVorVogVr4 BVorVogVr5 
            TRUE       TRUE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BVorVogVg1 BVorVogDae BVorVogNda BVorVovVr1 BVorVovVr2 BVorVovVr3 BVorVovVr4 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BVorVovVr5 BVorVovVo1 BVorVopVr1 BVorVopVr2 BVorVopVr3 BVorVopVr4 BVorVopVr5 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BVorVopVo1 BVorVlcLi1 BVorVlcLi2 BVorVlcLi3 BVorVlcLi4 BVorVlcLi5 BVorVaoNtv 
           FALSE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BVorVaoVuh BVorVbkVbk BVorVbkTvo BVorVbkTvl BVorVbkTvv BVorVbkTtv BVorVbkInd 
            TRUE       TRUE      FALSE       TRUE       TRUE       TRUE       TRUE 
      BVorVbkTtb BVorLbvBlk BVorLbvCba BVorLbvCfo BVorTskTos BVorTskTls BVorTskTvs 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BVorVpkTto BVorVpkTop BVorOvrLvb BVorOvrLvc BVorOvrLek BVorOvrRcb BVorOvrRcc 
            TRUE       TRUE       TRUE       TRUE       TRUE      FALSE      FALSE 
      BVorOvrRco BVorOvrRca BVorOvrWbs BVorOvrVrb BVorOvrTvr BVorOvrTvo BVorOvrOvk 
           FALSE      FALSE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BVorOvrLen BVorOvrIln BVorOvrMcd BVorOvrOvd BVorOvrOvn BVorOvaVof BVorOvaVbs 
           FALSE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BVorOvaNtf BVorOvaNoo BVorOvaNtp BVorOvaNth BVorOvaNov BVorOvaNob BVorOvaVop 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BVorOvaVoh BVorOvaVem BVorOvaVov BVorOvaVak BVorOvaVtr BVorOvaVok BVorOvaVoo 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BVorOvaVas BVorOvaVae BVorOvaVoa BVorOvaVkf BVorOvaVan BVorOvaTor BVorOvaVbr 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BVorOvaOoa BVorOvaErf BVorOvaNos BVorOvaNtr BVorOvaPen BVorTusTbt BVorTusTsa 
            TRUE       TRUE       TRUE       TRUE       TRUE      FALSE      FALSE 
      BVorTusTin BVorTusTpj BVorTusTpr BVorTusTdv BVorTusTvr BVorTusTvk BVorTusTon 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BVorTusTov BVorTusLen BVorOvhVor BEffAanAbe BEffAanAnb BEffOblObb BEffOblOnb 
           FALSE      FALSE       TRUE      FALSE      FALSE      FALSE      FALSE 
      BEffOveOeb BEffOveOen BEffOptOpb BEffOptOpn BEffOpvOpb BEffOpvOpn BEffDerDer 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BLimKasKas BLimKasKlk BLimBanRba BLimBanDrk BLimBanDep BLimBanBel BLimBanGrb 
            TRUE       TRUE      FALSE       TRUE       TRUE       TRUE       TRUE 
      BLimBanInb BLimBanSpa BLimKruSto BLimKruKlu BLimKruPib BLimKruCra BLimKruWec 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BEivGokGea BEivGokPra BEivGokPri BEivGokCva BEivGokZea BEivGokWia BEivGokEia 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BEivSevSti BEivSevVnk BEivSevCoo BEivCokCok BEivAgiAgi BEivHerHew BEivWerNba 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BEivWerRla BEivWerRvi BEivWerRvl BEivWerRvg BEivWerRgk BEivWerRed BEivWerRvo 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BEivWerKoe BEivStrStr BEivBefBef BEivBerBer BEivFijFij BEivOvrAlr BEivOvrOrs 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BEivOvrCor BEivOreOvw BEivOreRvh BEivOreVde BEivOreUpd BEivKapOnd BEivKapPrs 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BEivKapPro BEivKa2Ond BEivKa2Prs BEivKa2Pro BEivKa3Ond BEivKa3Prs BEivKa3Pro 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BEivKa4Ond BEivKa4Prs BEivKa4Pro BEivKa5Ond BEivKa5Prs BEivKa5Pro BEivOkcInk 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BEivOkcKeg BEivFirHer BEivFirFor BEivFirOpw BEivFirRae BEivFirExp BEivFirRis 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BEivFirTer BEivFirOfr BEivAvdAvd BEgaEgaEga BVrzVvpVpd BVrzVvpBac BVrzVvbVlb 
           FALSE      FALSE       TRUE      FALSE      FALSE      FALSE      FALSE 
      BVrzVvbVvb BVrzOvzVhe BVrzOvzVvo BVrzOvzVuc BVrzOvzVvg BVrzOvzVwp BVrzOvzVlc 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BVrzOvzVir BVrzOvzVid BVrzOvzGar BVrzOvzJub BVrzOvzArb BVrzOvzOvz BVrzOvzOio 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BVrzOvzOiv BVrzOvzLob BVrzOvzZoa BVrzOvzUhp BVrzOvzAgb BVrzOvzVza BVrzOihOrt 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BLasAclAll BLasAclCla BLasColCll BLasColCla BLasAoeAol BLasAoeCla BLasFlvFlv 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BLasFlvCla BLasSakHvl BLasSakCla BLasSakFvl BLasSakFca BLasSakLvl BLasSakLca 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BLasSakOvl BLasSakOca BLasSakWsl BLasSakWsa BLasSakGol BLasSakGoa BLasVobVob 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BLasVobVoc BLasSalSal BLasSalSac BLasTbwTbw BLasTbwTbc BLasSagHoo BLasSagAfl 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BLasSaoHoo BLasSaoAfl BLasSapHoo BLasSapAfl BLasBepBep BLasBepBec BLasSuhSuh 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BLasSuhSuc BLasStzStz BLasStzStc BLasNegBrw BLasNegCbd BLasOdvOdv BLasParPar 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BLasParCla BLasSohSoh BLasSohAso BLasSohWsw BLasSohAws BLasSohGos BLasSohGoa 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BLasVhzVhz BLasOlsOsl BLasOlsAfl BLasOlsIlg BLasOlsIla BLasOlsWbs BLasOlsWba 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BLasOlsDer BLasOlsDea BLasOvpOvp BLasOvpOva BSchKolAlk BSchKolClk BSchKolAok 
           FALSE      FALSE      FALSE      FALSE       TRUE       TRUE       TRUE 
      BSchKolAov BSchKolDer BSchSohSoh BSchSakRba BSchVobVgf BSchVobVob BSchCreHac 
            TRUE      FALSE       TRUE      FALSE       TRUE       TRUE       TRUE 
      BSchCreHci BSchCreVbk BSchCreKcr BSchCreTus BSchCreTtf BSchTbwAvp BSchTbwTbr 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BSchTbwOvs BSchSagSg1 BSchSagSg2 BSchSagSg3 BSchSagSg4 BSchSagSg5 BSchSagDae 
            TRUE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BSchSagNda BSchSaoSo1 BSchSaoSo2 BSchSaoSo3 BSchSaoSo4 BSchSaoSo5 BSchSapSp1 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BSchSapSp2 BSchSapSp3 BSchSapSp4 BSchSapSp5 BSchShbShb BSchFlkFlk BSchBepBtw 
           FALSE      FALSE      FALSE      FALSE       TRUE       TRUE      FALSE 
      BSchBepLhe BSchBepVpb BSchBepOvb BSchStzPen BSchAosHvk BSchAosLvk BSchAosFvk 
           FALSE      FALSE      FALSE       TRUE       TRUE       TRUE       TRUE 
      BSchAosAos BSchAosMvl BSchOppOpp BSchSalNet BSchSalVpe BSchSalTan BSchSalTvg 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BSchSalTbv BSchSalVab BSchSalBls BSchSalOrn BSchSalPsv BSchSalPer BSchSalOna 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BSchSalGra BSchOvsRcb BSchOvsRcc BSchOvsRco BSchOvsSaa BSchOvsOvi BSchOvsTbd 
            TRUE      FALSE      FALSE      FALSE      FALSE       TRUE       TRUE 
      BSchOvsGif BSchOvsSuv BSchOvsStp BSchOvsVvv BSchOvsVpo BSchOvsOvs BSchOvsWaa 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BSchOvsLed BSchOvsLoy BSchOpaNto BSchOpaNtb BSchOpaTbr BSchOpaVor BSchOpaOop 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BSchOpaNbs BSchOpaNom BSchOpaNpr BSchOpaNbh BSchOpaNve BSchOpaNbi BSchOpaNpe 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BSchOpaNhv BSchOpaNee BSchOpaNvk BSchOpaNak BSchOpaNtk BSchOpaNkk BSchOpaNok 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BSchOpaNas BSchOpaNaa BSchOpaNad BSchOpaNkf BSchOpaErf BSchOpaHur BSchOpaVhr 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BSchOpaKsv BSchOpaNao BSchOpaVgo BSchOpaPen BSchTusTbt BSchTusTsa BSchTusTin 
            TRUE       TRUE       TRUE       TRUE      FALSE      FALSE      FALSE 
      BSchTusTpj BSchTusTpr BSchTusTdv BSchTusTvr BSchTusTvk BSchTusTon BSchTusTov 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      BSchTusLen BSchDhaDha BSchDhaVde BSchDhpDhp BSchSdnDae BSchSdnNda BSchSlcLi1 
           FALSE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      BSchSlcLi2 BSchSlcLi3 BSchSlcLi4 BSchSlcLi5 WOmzNopOlh WOmzNopOlv WOmzNopOlo 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WOmzNopOpg WOmzNopOlg WOmzNopOll WOmzNopOln WOmzNopOli WOmzNopOla WOmzNopOlu 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WOmzNopOle WOmzNopNon WOmzNopNod WOmzNohOlh WOmzNohOlv WOmzNohOlo WOmzNohMai 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WOmzNohOmr WOmzNohOpg WOmzNohOlg WOmzNohOll WOmzNohOln WOmzNohOli WOmzNohOla 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WOmzNohOlu WOmzNohOle WOmzNohNon WOmzNohNod WOmzNodOdh WOmzNodOdl WOmzNodOdo 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WOmzNodOpd WOmzNodOdg WOmzNodOdv WOmzNodOdb WOmzNodOdi WOmzNodOda WOmzNodOdu 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WOmzNodOde WOmzNodNon WOmzNodNod WOmzAolPom WOmzAolVpa WOmzAolGms WOmzAolVee 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WOmzAolVwd WOmzAolOno WOmzAovVmu WOmzAovOzv WOmzAovOea WOmzAovBts WOmzAovMel 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WOmzAovEie WOmzNooNdl WOmzNooNdy WOmzNooNdd WOmzNooOur WOmzNooOnw WOmzNooNdo 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WOmzNooNon WOmzNooNtf WOmzOitOit WOmzOitOvg WOmzOitOvm WOmzOitOvd WOmzKebVek 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE      FALSE 
      WOmzKebOmz WOmzKebPrv WOmzGrpGr1 WOmzGrpGr2 WOmzGrpGr3 WOmzGrpGr4 WOmzGrpGr5 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      WRevHuoHuo WRevOscOsc WRevLscLsc WRevOhbOhb WRevLvbLvb WRevLoaLoa WRevOolOol 
           FALSE      FALSE      FALSE       TRUE      FALSE      FALSE      FALSE 
      WRviOvoOvo WRviUvvUvv WRviTokTok WRviTfkTfk WRgrOvpOvp WRgrTokTok WRgrRvbLsc 
            TRUE      FALSE      FALSE       TRUE       TRUE      FALSE       TRUE 
      WRgrDkvVkk WRgrDkvVbm WRgrDkvMaf WWvvOwvOwv WWvvOwvTok WWvvNwpNwp WWvvNwvNwv 
            TRUE       TRUE       TRUE      FALSE      FALSE       TRUE       TRUE 
      WWvvNwbNwb WNoaOoaOoa WNoaKoaKoa WOokOokOkn WOokOokDok WOokOokShf WOokOokBhf 
            TRUE      FALSE      FALSE       TRUE       TRUE       TRUE       TRUE 
      WKolKolLee WVkfVkfVkf WAkfAkfAkf WWivWgpWgp WWivWowWow WWivWopWop WWivGpvGpe 
           FALSE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WWivGpvPge WWivWavAaf WWivWavAav WWivWavOvv WWivWvaWva WKprKvgKvg WKprKvgKgi 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WKprKvgVrv WKprKvgPrv WKprKvgDfw WKprKvpKvp WKprKvpDfw WKprKuwKuw WKprKuwAek 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WKprKuwDfw WKprAklTee WKprAklZpe WKprAklSmk WKprAklBdm WKprAklBek WKprAklGew 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WKprAklGvk WKprAklAft WKprAklCoe WKprAklPeg WKprAklOte WKprAklGko WKprAklEkn 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WKprAklWkn WKprAklOwk WKprAklLew WKprAklVkn WKprAklAve WKprAklPah WKprAklTra 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WKprAklCtk WKprAklVwa WKprAklPbk WKprAklAaf WKprAklSod WKprAklCkn WKprAklAfc 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WKprInaLpk WKprInaLph WKprInaLpo WKprInaLpt WKprInaLbh WKprAkvVks WKprAkvGez 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WKprAkvKie WKprAkvTee WKprAkvSkn WKprAkvEne WKprAkvOve WKprAkvMes WKprAkvLep 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WKprAkvEie WKprAkvKvk WKprAkvRuw WKprAkvBik WKprAkvVgd WKprAkvAvb WKprAkvAam 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WKprAkvAjo WKprAkvMel WKprAkvLve WKprKraKra WKprKraKva WKprKraDfw WKprInhInh 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WKprInhVrv WKprInhPrv WKprInhDfw WKprInpInp WKprInpVrv WKprInpPrv WKprInpDfw 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WKprLebLeb WKprLebInp WKprLebDfw WKprBtkBed WKprBtkBec WKprBtkDfw WKprKitKit 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WKprKitDfw WKprMuoMuo WKprMuoDfw WKprVomVom WKprVomDfw WKprPrgPrg WKprPrgDfw 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WKprPrdPrd WKprPrdDfw WKprGrpGr1 WKprGrpGr2 WKprGrpGr3 WKprGrpGr4 WKprGrpGr5 
            TRUE       TRUE      FALSE      FALSE      FALSE      FALSE      FALSE 
      WKprGrpDfw WKprOniOn1 WKprTvlIgp WKprTvlVsg WKprTvlLbd WKprTvlWko WKprTvlKba 
            TRUE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      WKprTvlAla WOvbLpdLpd WOvbOrsOel WOvbOrsOre WOvbOrsOsu WOvbSpdSpd WOvbBueCol 
           FALSE      FALSE       TRUE      FALSE      FALSE       TRUE       TRUE 
      WOvbBueDeg WOvbBueCtb WOvbBueSpo WOvbBueNal WOvbBueEle WOvbBueVeg WOvbBueObu 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WOvbBugCol WOvbBugDeg WOvbBugCtb WOvbBugSpo WOvbBugNal WOvbBugEle WOvbBugVeg 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WOvbBugObu WOvbBuaCol WOvbBuaDeg WOvbBuaCtb WOvbBuaSpo WOvbBuaNal WOvbBuaEle 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WOvbBuaVeg WOvbBuaObu WOvbHuoHuo WOvbOpsOps WOvbCclCcl WOvbNvvNvv WOvbBwiBwi 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WOvbOnmOnm WOvbOdpOdp WOvbOvoOvo WOvbVezUib WOvbVezOvu WOvbSgbBvd WOvbSgbBvl 
            TRUE       TRUE       TRUE       TRUE       TRUE      FALSE      FALSE 
      WOvbSgbBvp WOvbSgbBvb WOvbSgbBlo WOvbSgbBso WOvbSgbBvo WOvbSgbBao WOvbSgbAnb 
           FALSE      FALSE      FALSE      FALSE      FALSE      FALSE      FALSE 
      WOvbDobEvp WOvbDobVvo WOvbDobGrv WOvbDobWvp WOvbDobOac WOvbDobLbh WPerLesSld 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE      FALSE 
      WPerLesBvc WPerLesTep WPerLesLon WPerLesOwe WPerLesOnr WPerLesVag WPerLesVad 
           FALSE       TRUE      FALSE       TRUE       TRUE      FALSE       TRUE 
      WPerLesGra WPerLesLin WPerLesTls WPerLesOnu WPerLesLiv WPerLesLoo WPerLesOvt 
           FALSE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WPerLesOlr WPerLesLks WPerLesOls WPerLesDle WPerLesDfw WPerSolPsv WPerSolBiz 
           FALSE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WPerSolOpr WPerSolOsf WPerSolOss WPerSolDsl WPerSolDfw WPerPenPen WPerPenAap 
            TRUE       TRUE      FALSE       TRUE       TRUE      FALSE      FALSE 
      WPerPenDpe WPerPenVpv WPerPenDvb WPerPenVvb WPerPenDvl WPerPenVvl WPerPenOpe 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE      FALSE 
      WPerPenDon WPerPenDfw WPerOluOlp WPerOluDfw WAfsAivOek WAfsAivKoe WAfsAivCev 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WAfsAivGoo WAfsAivViv WAfsAivOiv WAfsAivBou WAfsAivDfw WAfsAmvAft WAfsAmvBeg 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WAfsAmvHuu WAfsAmvVeb WAfsAmvMei WAfsAmvObe WAfsAmvSev WAfsAmvAfs WAfsAmvTev 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WAfsAmvBei WAfsAmvAmp WAfsAmvAfg WAfsAmvVbi WAfsAmvAvm WAfsAmvBgm WAfsAmvOrz 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WAfsAmvDfw WAfsAfvAvo WAfsAfvAve WAfsAfvDfw WAfsRviOek WAfsRviKoe WAfsRviCev 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WAfsRviGoo WAfsRviViv WAfsRviOiv WAfsRviBou WAfsRviDfw WAfsRvmBrt WAfsRvmBeg 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WAfsRvmHuu WAfsRvmVeb WAfsRvmMei WAfsRvmObe WAfsRvmSev WAfsRvmSch WAfsRvmTev 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WAfsRvmBei WAfsRvmBmp WAfsRvmBgv WAfsRvmVbi WAfsRvmBvm WAfsRvmBgm WAfsRvmOrz 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WAfsRvmDfw WAfsBovBvo WAfsBovBve WAfsBovDfw WAfsDaeDaf WAfsDaeDow WAfsDaeDve 
            TRUE       TRUE       TRUE       TRUE      FALSE      FALSE      FALSE 
      WAfsDaeDfw WWviWviBwi WWviWviTbi WWviWviDfw WWviWvmBwm WWviWvmTbm WWviWvmDfw 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WWviWvbBwv WWviWvbTbw WWviWvbDfw WBwvObwBwv WBwvObwDfw WBwvGwbGwb WBwvGwbDfw 
            TRUE       TRUE       TRUE      FALSE       TRUE      FALSE       TRUE 
      WBwvNwbNwb WBwvNwbDfw WBedWkrWkf WBedWkrWkn WBedWkrWkg WBedWkrWkc WBedWkrWki 
           FALSE       TRUE      FALSE      FALSE      FALSE      FALSE      FALSE 
      WBedWkrWkb WBedWkrWkv WBedWkrWko WBedOvpUik WBedOvpUit WBedOvpMaf WBedOvpZzp 
           FALSE      FALSE      FALSE      FALSE       TRUE       TRUE       TRUE 
      WBedOvpPay WBedOvpOip WBedOvpWer WBedOvpAbd WBedOvpDdd WBedOvpZie WBedOvpOzi 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedOvpDvr WBedOvpVvr WBedOvpDoa WBedOvpDoj WBedOvpVva WBedOvpVrj WBedOvpObp 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedOvpOvp WBedOvpDop WBedOvpLbo WBedOvpDfw WBedHuiErf WBedHuiLee WBedHuiLas 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedHuiBeh WBedHuiOhu WBedHuiHuw WBedHuiOnt WBedHuiOng WBedHuiSch WBedHuiSer 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedHuiGwe WBedHuiPre WBedHuiAoz WBedHuiOnz WBedHuiMez WBedHuiObh WBedHuiOvh 
           FALSE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedHuiDrg WBedHuiVrg WBedHuiDvg WBedHuiVgb WBedHuiDkg WBedHuiVkg WBedHuiOhv 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE      FALSE 
      WBedHuiDoh WBedHuiDfw WBedEemRoi WBedEemOls WBedEemHui WBedEemKai WBedEemGsk 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedEemDvi WBedEemVoi WBedEemDki WBedEemVki WBedEemOki WBedEemRom WBedEemOlm 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedEemHum WBedEemOme WBedEemBrm WBedEemKam WBedEemDvm WBedEemVgo WBedEemDkm 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedEemVkm WBedEemObm WBedEemOkm WBedEemWdi WBedEemWdd WBedEemDrm WBedEemVrm 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedEemAme WBedEemVpm WBedEemOee WBedEemDem WBedEemDfw WBedVkkRea WBedVkkKos 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedVkkBeu WBedVkkRel WBedVkkKer WBedVkkRep WBedVkkRev WBedVkkEta WBedVkkVrk 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedVkkInc WBedVkkKmz WBedVkkKmw WBedVkkVkp WBedVkkCom WBedVkkFra WBedVkkDvd 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedVkkAdd WBedVkkDog WBedVkkVgv WBedVkkWeb WBedVkkObs WBedVkkOvr WBedVkkDbv 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedVkkDfw WBedAutBra WBedAutRoa WBedAutAsa WBedAutMot WBedAutOpa WBedAutBwl 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedAutPga WBedAutBop WBedAutHua WBedAutKil WBedAutBeb WBedAutObv WBedAutDrv 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedAutVrv WBedAutDkv WBedAutVkv WBedAutDvv WBedAutVoa WBedAutPar WBedAutOak 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedAutDau WBedAutDfw WBedTraBrr WBedTraRot WBedTraAst WBedTraMot WBedTraOpt 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedTraPgt WBedTraBot WBedTraHut WBedTraObt WBedTraDrt WBedTraVrt WBedTraDkt 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedTraVkt WBedTraDvt WBedTraVot WBedTraPar WBedTraOtr WBedTraDot WBedTraDfw 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedKanKan WBedKanPor WBedKanTef WBedKanPrt WBedKanDru WBedKanKak WBedKanCea 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedKanVak WBedKanBoe WBedKanInc WBedKanKoa WBedKanAss WBedKanOba WBedKanRok 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedKanOka WBedKanDka WBedKanCom WBedKanDfw WBedOrgHol WBedOrgDmf WBedOrgFra 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedOrgOeo WBedOrgLgv WBedOrgOct WBedOrgOok WBedOrgDoo WBedOrgWrc WBedOrgDfw 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedAssBea WBedAssOva WBedAssScb WBedAssSco WBedAssDas WBedAssAvk WBedAssBhk 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedAssDfw WBedAeaAea WBedAeaPda WBedAeaNot WBedAeaAej WBedAeaAdv WBedAeaDae 
            TRUE      FALSE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedAeaDfw WBedAdlHef WBedAdlOvb WBedAdlKav WBedAdlBan WBedAdlVal WBedAdlBov 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedAdlBet WBedAdlBev WBedAdlNao WBedAdlNbo WBedAdlBtk WBedAdlOad WBedAdlDal 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedAdlKlv WBedAdlOpr WBedAdlDfw WBedKofBad WBedKofKef WBedKofKgf WBedKofKfv 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedKofKvs WBedKofDfw WBedKseAbs WBedKseLiu WBedKseDfw WBedDvrDfr WBedDvrVfr 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedDvrDfw WBedDvvDvu WBedDvvDvh WBedDvvDvo WBedDvvDvc WBedDvvDvw WBedDvvDov 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedDvvVvu WBedDvvVvh WBedDvvVvm WBedDvvVvc WBedDvvVvw WBedDvvVov WBedDvvDfw 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBedAlkOal WBedAlkDak WBedAlkDfw WBedBnoBno WBedLnoLno WOvtRofRig WOvtRofRug 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WOvtRofRvp WOvtRofRvi WOvtRofRvu WOvtRofRid WOvtRofRud WOvtRofRva WOvtRofRvd 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WOvtRofRov WOvtRofDiv WOvtRofOoe WOvtRofRor WVheVuhVuh WVheVeiVei WVheVoeVoe 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WWfaBwvFva WWfaBwvWse WWfaBwvOef WWfaBwvTwf WWfaBwvTwe WWfaBwvOvp WWfaBwvTok 
           FALSE       TRUE       TRUE       TRUE       TRUE       TRUE      FALSE 
      WWfaBwvLsc WWfaBwvVvk WWfaBwvVbm WFbeRlmRgi WFbeRlmRgu WFbeRlmRmi WFbeRlmRmu 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WFbeRlmRdi WFbeRlmRdu WFbeRlmRlm WFbeRlmOdr WFbeRlmObr WFbeRlmRva WFbeRlmRvf 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WFbeRlmRrb WFbeRlmRrc WFbeRlmRbb WFbeRlmRil WFbeRlmKgd WFbeRlmCol WFbeRlmCfv 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WFbeRlmKsw WFbeRlmAre WFbeRlmInc WFbeRlmMvl WFbeRlsRal WFbeRlsRcl WFbeRlsRob 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WFbeRlsRol WFbeRlsRhl WFbeRlsRle WFbeRlsRef WFbeRlsRlk WFbeRlsRlv WFbeRlsRlo 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WFbeRlsRgi WFbeRlsRgu WFbeRlsRmi WFbeRlsRmu WFbeRlsRdi WFbeRlsRdu WFbeRlsRsa 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WFbeRlsRsf WFbeRlsRsd WFbeRlsRsc WFbeRlsRil WFbeRlsRps WFbeRlsNhr WFbeOrlRpe 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WFbeOrlRli WFbeOrlRlb WFbeOrlRos WFbeOrlRkb WFbeOrlWbs WFbeOrlRld WFbeOrlRls 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WFbeOrlOrl WFbeOrlWsw WFbeWisWis WFbeKvbKvb WFbeKbaKba WFbeOnnOnn WFbeWnnWnn 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WFbeDerMmd WFbeDerMal WFbeDerMme WFbeDerMae WFbePolPol WFbePhpPhp WFbeAadAad 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WFbeNolNol WFbeDfbDrb WFbeDfbDrl WFbeDfbDof WFbeNhpNhp WFbeAlpAlp WFbeEmkEmk 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WFbeKvaKva WFbeBkfBkf WFbeVlrVlr WFbeRflRfl WBelBgrLab WBelBgrBgr WBelBgrBuv 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WBelBgrWlb WBelBgrOvb WRedAirAwd WRedAirGrp WRedAirOvd WRedAirDvn WRedAirVvi 
            TRUE       TRUE       TRUE      FALSE       TRUE       TRUE       TRUE 
      WRedAirAwb WRedArvAwd WRedArvGrp WRedArvOvd WRedArvDvn WRedArvVvi WRedArvAwb 
            TRUE       TRUE       TRUE       TRUE       TRUE       TRUE       TRUE 
      WLbeLbvLbv WAadRavRav WNerNewNew WMfoBelMfo 
            TRUE       TRUE       TRUE       TRUE 

---

    Code
      endnote_seeker(RGS)
    Output
      # A tibble: 4,564 x 26
         referentiecode referentie_omsla~ sortering referentienummer omschrijving_ver~
         <chr>          <chr>             <chr>     <chr>            <chr>            
       1 B              <NA>              <NA>      <NA>             BALANS           
       2 BIva           <NA>              A         01               Immateriële vast~
       3 BIvaKou        <NA>              A.A       0101000          Kosten van opric~
       4 BIvaKouVvp     <NA>              A.A.A     0101010          Verkrijgings- of~
       5 BIvaKouAkp     <NA>              A.A.A1    101015           Actuele kostprijs
       6 BIvaKouAkpBeg  <NA>              A.A.A110  0101015.01       Beginbalans (ove~
       7 BIvaKouAkpInv  <NA>              A.A.A120  0101015.02       Investeringen    
       8 BIvaKouAkpAdo  <NA>              A.A.A130  0101015.03       Bij overname ver~
       9 BIvaKouAkpDes  <NA>              A.A.A140  0101015.04       Desinvesteringen 
      10 BIvaKouAkpDda  <NA>              A.A.A150  0101015.05       Afstotingen      
      # ... with 4,554 more rows, and 21 more variables: omschrijving <chr>,
      #   d_c <chr>, nivo <dbl>, zzp_belastingdienst_pilot_zol_awa <lgl>,
      #   basis <lgl>, uitgebr <lgl>, ez_vof_12 <lgl>, zzp <lgl>, wo_co_14 <lgl>,
      #   bb <lgl>, agro <lgl>, wkr <lgl>, ez_vof_18 <lgl>, bv <lgl>, wo_co_20 <lgl>,
      #   bank <lgl>, ozw_coop_sticht_fwo <lgl>, afrek_syst <lgl>, nivo5 <lgl>,
      #   uitbr5 <lgl>, terminal <lgl>

---

    Code
      endnote_seeker(dplyr::filter(RGS, .data$nivo < 3))
    Output
      # A tibble: 44 x 26
         referentiecode referentie_omsla~ sortering referentienummer omschrijving_ver~
         <chr>          <chr>             <chr>     <chr>            <chr>            
       1 B              <NA>              <NA>      <NA>             BALANS           
       2 BIva           <NA>              A         01               Immateriële vast~
       3 BMva           <NA>              B         02               Materiële vaste ~
       4 BVas           <NA>              C         02.01            Vastgoedbeleggin~
       5 BFva           <NA>              D         03               Financiële vaste~
       6 BVrd           <NA>              E         30               Voorraden        
       7 BPro           <NA>              F         35               Onderhanden proj~
       8 BVor           <NA>              G         11               Vorderingen      
       9 BEff           <NA>              H         04               Effecten (kortlo~
      10 BLim           <NA>              I         10               Liquide middelen 
      # ... with 34 more rows, and 21 more variables: omschrijving <chr>, d_c <chr>,
      #   nivo <dbl>, zzp_belastingdienst_pilot_zol_awa <lgl>, basis <lgl>,
      #   uitgebr <lgl>, ez_vof_12 <lgl>, zzp <lgl>, wo_co_14 <lgl>, bb <lgl>,
      #   agro <lgl>, wkr <lgl>, ez_vof_18 <lgl>, bv <lgl>, wo_co_20 <lgl>,
      #   bank <lgl>, ozw_coop_sticht_fwo <lgl>, afrek_syst <lgl>, nivo5 <lgl>,
      #   uitbr5 <lgl>, terminal <lgl>

---

    Code
      endnote_seeker(dplyr::filter(RGS, .data$nivo < 2))
    Output
      # A tibble: 2 x 26
        referentiecode referentie_omslag~ sortering referentienummer omschrijving_ver~
        <chr>          <chr>              <chr>     <chr>            <chr>            
      1 B              <NA>               <NA>      <NA>             BALANS           
      2 W              <NA>               <NA>      <NA>             WINST- EN VERLIE~
      # ... with 21 more variables: omschrijving <chr>, d_c <chr>, nivo <dbl>,
      #   zzp_belastingdienst_pilot_zol_awa <lgl>, basis <lgl>, uitgebr <lgl>,
      #   ez_vof_12 <lgl>, zzp <lgl>, wo_co_14 <lgl>, bb <lgl>, agro <lgl>,
      #   wkr <lgl>, ez_vof_18 <lgl>, bv <lgl>, wo_co_20 <lgl>, bank <lgl>,
      #   ozw_coop_sticht_fwo <lgl>, afrek_syst <lgl>, nivo5 <lgl>, uitbr5 <lgl>,
      #   terminal <lgl>

---

    Code
      endnote_seeker(dplyr::filter(RGS, .data$d_c == "C" | is.na(.data$d_c)))
    Output
      # A tibble: 2,159 x 26
         referentiecode referentie_omsla~ sortering referentienummer omschrijving_ver~
         <chr>          <chr>             <chr>     <chr>            <chr>            
       1 B              <NA>              <NA>      <NA>             BALANS           
       2 BIvaKouAkpDes  <NA>              A.A.A140  0101015.04       Desinvesteringen 
       3 BIvaKouAkpDda  <NA>              A.A.A150  0101015.05       Afstotingen      
       4 BIvaKouCae     <NA>              A.A.B     0101020          Cumulatieve afsc~
       5 BIvaKouCaeBeg  <NA>              A.A.B010  0101020.01       Beginbalans (ove~
       6 BIvaKouCaeAfs  <NA>              A.A.B020  0101020.02       Afschrijvingen   
       7 BIvaKouCaeWvr  <NA>              A.A.B040  0101020.04       Bijzondere waard~
       8 BIvaKouCuhAfh  <NA>              A.A.C030  0101030.03       Afschrijving her~
       9 BIvaKouCuhDeh  <NA>              A.A.C040  0101030.04       Desinvestering h~
      10 BIvaKooVvpDes  <NA>              A.B.A040  0102010.04       Desinvesteringen 
      # ... with 2,149 more rows, and 21 more variables: omschrijving <chr>,
      #   d_c <chr>, nivo <dbl>, zzp_belastingdienst_pilot_zol_awa <lgl>,
      #   basis <lgl>, uitgebr <lgl>, ez_vof_12 <lgl>, zzp <lgl>, wo_co_14 <lgl>,
      #   bb <lgl>, agro <lgl>, wkr <lgl>, ez_vof_18 <lgl>, bv <lgl>, wo_co_20 <lgl>,
      #   bank <lgl>, ozw_coop_sticht_fwo <lgl>, afrek_syst <lgl>, nivo5 <lgl>,
      #   uitbr5 <lgl>, terminal <lgl>

