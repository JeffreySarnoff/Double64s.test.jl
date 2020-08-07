#=
   The Exponential Functions `exp(x)` and `exp(z)`.
   The associaed functions `expm1(x)` and `expm1(z)`.
=#

const Ln2 = FloatD64((0.6931471805599453, 2.3190468138462996e-17))

function exp_specialvalues(x::Float64)
   isnan(x) && return x
   absx = abs(x)
   absx > 709.0 && return signbit(x) ? -InfD64 : InfD64
   abx < 2.0^-257 && return one(FloatD64)
   return nothing
end

function Base.exp(x::FloatD64)
   exp_specialvalues(Hi(x))
   # 4.3108e-78 <= absx < 709.9
   absx = abs(x)
   
   # Solve for k satisfying x = 2^k * log(2) r
   #   with |r| <= 1/2 log(2)
   k = ceil(Int64, (absx / Ln2) - 0.5)
   # p = 2^k
   p = Int64(1) << k
   # Determine r using the k we computed
   r = absx - (k * Ln2)
  
end

#=
   source: Efficient implementation of elementary functions in the medium-precision range
           by Fredrik Johansson
           section 3: Argument reduction

   result = exp(x)

   m = fld(x, log(2))
   t = x - m * log(2)

  julia> FF4(log(BigFloat(2)))
  (0.6931471805599453, 2.3190468138462996e-17, 5.707708438416212e-34, -3.5824322106018114e-50)
  julia> FF4(exp(BigFloat(1)))
  (2.718281828459045, 1.4456468917292502e-16, -2.1277171080381768e-33, 1.5156301598412191e-49)
  julia> FF4(exp(BigFloat(-1)))
  (0.36787944117144233, -1.2428753672788363e-17, -5.830044851072742e-34, -2.8267977849017436e-50)
  log2(exp(1))
  (1.4426950408889634, 2.0355273740931033e-17, -1.0614659956117258e-33, -1.3836716780181402e-50)

   exp(x) = exp(t) * (2.0^m)
            where t  in [0, log(2)) # log(2) ~0.6931471805599453

   exp(t) = (exp(t/(2.0^r)))^(2.0^r)
            where t/(2.0^r) in [0, 2.0^(-r))   # at the expense of r squarings
                                
julia> 2.0^(-8) = 0.00390625
julia> 2.0^(-9) = 0.001953125

   if we precompute exp(i/(2^r)) for i = 0..(2^r - 1)
      we can write exp(x) = exp(x - i/2^r) * exp(i/2^r)  wher i = floor(x * 2^r)
      this achieves r halvings of argument reduction for the cost of a multiplication


sum([x^k / factorial(k) for k=0:n]) # perhaps 11
ex2(x,n) = sum([(x^(2*k) * (1 + 2*k +x)) / factorial(1+2*k) for k=0:n])  # 5 perhaps 6

=#
#=
ir(r) = collect(0:(2^r - 1));
ir2(r1,r2) = collect((2^r1):(2^r2 - 1))
exps(r) = exp.(ir(r) / big"2"^r)
exps2(r1,r2) = exp.(ir2(r1,r2) / big"2"^r2)

expi1 = exps(8);
expi2 = exps2(8,9);
expi1s = expi1[1:128]; # length 128
expi2s = expi2; # leingth 256

expi1s[1],expi1s[end]
(1.0, 1.642293515618909941146175177943829065898476010090130767464052857406618001282157)
expi2s[1],expi2s[end]
(1.648721270700128146848650787814163571653776100710148011575079311640661021194214, 2.712977865600149830047947983547967696224441828481010944922219814560357243651112)

# 256 values
expi = [
big"1.0",
big"1.0039138893383475734436096039034602818988136",
big"1.0078430972064479776934535597601235791933921",
big"1.0117876835593314915141138433716067245783427",
big"1.0157477085866857474585350720823517489067163",
big"1.0197232327137741547831816318953623989389768",
big"1.0237143166023579169688505321657689580745566",
big"1.0277210211516216579160287393882763310060287",
big"1.0317434074991026709387478152815071441944983",
big"1.0357815370216238047361682727501377703668922",
big"1.0398354713362300005766220098751917925969306",
big"1.0439052723011284949845543336459217728408202",
big"1.0479910020166327022767382918196849669390532",
big"1.0520927228261097913502841465226716758711456",
big"1.0562104973169319711813367037681297731537515",
big"1.0603443883214314995499437191070563220034387",
big"1.0644944589178594295633905946428896731007254",
big"1.0686607724313481086073309335198834903610129",
big"1.072843392434877444411300095010813766928624",
big"1.077042382750244952972680570165861926965078",
big"1.0812578074490396031408946517428286548338917",
big"1.0854897308536194727215323833540410098046093",
big"1.0897382175380932310182820254185122044095245",
big"1.0940033323293054627889171570399958544544903",
big"1.0982851403078258486502099342567867188098263",
big"1.1025837068089422170254848406286398617008396",
big"1.106899097423657482787602393741778963630765",
big"1.1112313779996904878094686123406995149077797",
big"1.1155806146424807586937045083794438798390782",
big"1.1199468737161971970128813548111838167408411",
big"1.1243302218447507174517329054449565537714046",
big"1.1287307259128108493029960233035576751121704",
big"1.1331484530668263168290072278117938725655031",
big"1.1375834707160496140618954216220641739226107",
big"1.1420358465335655896761614313488004988947112",
big"1.1465056484573240576286239229647318858420707",
big"1.1509929446911764493221396657803508410236923",
big"1.1554978037059165231111749561077458362413083",
big"1.1600202942403251470292152138940958101001022",
big"1.1645604853022191706801522774745177736791979",
big"1.1691184461695044022981846915118914445916047",
big"1.1736942463912327070434062632478574421242414",
big"1.1782879557886632426631433081958559090232306",
big"1.1828996444563278487122322779162386958636926",
big"1.1875293827631006055888078228331305661056264",
big"1.1921772413532715797057977592610942010914603",
big"1.1968432911476247711821968527700683464587539",
big"1.201527603344520280502316774392647998778235",
big"1.2062302494209807106555860104464335480403936",
big"1.2109513011337818213341018932134198490219412",
big"1.215690830520547451830018254540396832863575",
big"1.2204489099008487293399874776109514959456667",
big"1.2252256118773075794492659275775547905529261",
big"1.2300210093367045556337378772080063588467264",
big"1.2348351754510910046840161108760027424078237",
big"1.2396681836789055850219383947130699551294591",
big"1.2445201077660951549461989520766544581233531",
big"1.2493910217472400479105339951661133401110873",
big"1.2542809999466837520048212530906856313930507",
big"1.2591901169796670108766563253994731033558361",
big"1.2641184477534663633984346034590176916127065",
big"1.2690660674685371394526974695586839474881616",
big"1.2740330516196609292764965387163400150598443",
big"1.2790194759970975438737908883703017739782832",
big"1.2840254166877414840734205680624364583362809",
big"1.2890509500762829358789962405026343223583583",
big"1.2940961528463733098261106268100709645926577",
big"1.299161101981795342131613566113939048057404",
big"1.3042458747676377754893000110524664638914931",
big"1.3093505487914746374362402281617419935314083",
big"1.314475201944549134284134921979872958797392",
big"1.3196199124229621786805060243653563910202619",
big"1.3247847587288655689352375606889644453814644",
big"1.3299698196716598383189614010596868898353478",
big"1.335175174369196792611040910663613496051334",
big"1.3404009022489867542464426159453927247594736",
big"1.345647083049410531482603094316017723141301",
big"1.3509137968209361310794964701714017243589766",
big"1.3562011239273402330584882593857570013204578",
big"1.3615091450469344461782249525402249833846504",
big"1.3668379411737963628387567727212086721727333",
big"1.3721875936190054321983245998746874054136052",
big"1.3775581840118836703607622378892548520433121",
big"1.3829497943012412265652731346321226949971137",
big"1.3883625067566268243844374753000036641797537",
big"1.3937964039695830970106923862996621838753668",
big"1.3992515688549068357862059454951895801349576",
big"1.4047280846519141712060359345473907335921464",
big"1.4102260349257107056997279341815912975975336",
big"1.4157455035684666175720656019875394367736763",
big"1.4212865748006967555595399377075767858324404",
big"1.4268493331725457435352551903480186121366873",
big"1.4324338635650781149714379568249381105086462",
big"1.4380402511915734968454641297483462771412234",
big"1.4436685815988268627523668434427752933667452",
big"1.4493189406684538750641386180656840287525084",
big"1.454991414618201336053793691987518508346842",
big"1.4606860900032627679801132473277319831728503",
big"1.4664030537175991422072580622261772341235882",
big"1.4721423929952647775120012602512819589278704",
big"1.4779041954117384278102094711614577636044574",
big"1.4836885488852595796133850715926159360653458",
big"1.4894955416781699796055764474013653746366884",
big"1.4953252623982604128107686243383379457966073",
big"1.5011778000001227519009843681945126839847195",
big"1.5070532437865072982757571820568627066188943",
big"1.5129516834096854356243837541143330540396894",
big"1.518873208872817616763425566660741826592259",
big"1.5248179105313267046233088024596115443256307",
big"1.5307858790942766883395696202202495812292224",
big"1.5367772056257567954863095631977568976482128",
big"1.5427919815462710215717645653643101046597946",
big"1.5488302986341330979985519845954923375583037",
big"1.5548922490268669197741445831814759100397908",
big"1.5609779252226124543404296589529359617213441",
big"1.5670874200815371529748468766060916540358334",
big"1.5732208268272528862995610345959599306077298",
big"1.5793782390482384255194173094123070388118751",
big"1.5855597506992674910940477323437952296789346",
big"1.5917654561028423906344500651913320024805135",
big"1.5979954499506332678996451470842104572159357",
big"1.6042498273049229848546374859283226869322636",
big"1.6105286836000576588368576715138990015137373",
big"1.6168321146439028769645554044834985475711929",
big"1.6231602166193056100072398828952478310491124",
big"1.6295130860855618480252312878508519071585423",
big"1.6358908199798899801726944886054803066336858",
big"1.642293515618909941146175177943829065898476",
big"1.6487212707001281468486507878141635716537761",
big"1.6551741833034282419274450659151529161544963",
big"1.661652351892567681933037464039017553408944",
big"1.6681558753166801729348278516747020845493453",
big"1.6746848528117839915192948821484471915616397",
big"1.6812393840022962081857139672252104808506591",
big"1.6878195689025528372446796287495748265689688",
big"1.694425507918334936415108367064433784118984",
big"1.7010573018484006794061834954848285349306956",
big"1.7077150518860234248618440232984793229206938",
big"1.7143988596205358051369170173112717453784532",
big"1.7211088270388798584658483299957258431122154",
big"1.7278450565271632281772015524381343960105588",
big"1.7346076508722214526996709396061731128182903",
big"1.7413967132631863701982922765711232180120641",
big"1.7482123472930606617728376253439213210762717",
big"1.7550546569602985572440470365989676887382375",
big"1.7619237466703927276473840580130012741833298",
big"1.768819721237467388648403656081329732171722",
big"1.7757426858858776391885924315490433000564346",
big"1.7826927462518150597656831961070971624870767",
big"1.7896700083849195948479605415087339387426964",
big"1.7966745787498977440179624291990663920674301",
big"1.8037065642281470865372465220624332490665196",
big"1.8107660721193871641205304388476395701804874",
big"1.8178532101432967468045338108486506072754985",
big"1.8249680864411575068942484398874703584971162",
big"1.8321108095775041260671424827506305635923199",
big"1.8392814885417808608139669119715291919683603",
big"1.8464802327500045914933790240679012662617646",
big"1.8537071520464343803765299877394712853248167",
big"1.8609623567052475641570828556931428635577371",
big"1.8682459574322224065018356201881044531149723",
big"1.8755580653664273363172222955086314557144833",
big"1.8828987920819167975074551877605054582064688",
big"1.890268249589433736100954997008217074841387",
big"1.8976665503381187507229937281862390730851715",
big"1.9050938072172259324941501108153118386642345",
big"1.9125501335578454205362498947690069141803877",
big"1.9200356431346326993699355576741048656485595",
big"1.9275504501675446645908831925937307660930033",
big"1.9350946693235824833149602121576936617744414",
big"1.9426684157185412759862975831367569870468297",
big"1.9502718049187666462463361756410743039045826",
big"1.9579049529429180856664000618841160115832721",
big"1.965567976263739280251251825234587055462156",
big"1.9732609918098353457263977417630639167722963",
big"1.980984116967457018727635680625228052334163",
big"1.9887374695822918311174773496469253668482552",
big"1.9965211679612622947596307079391523309846108",
big"2.0043353308743311241896996041635187235500792",
big"2.0121800775563135247276476094443781622950744",
big"2.0200555277086965736853832365247240976992445",
big"2.0279618015014657224310559166446580204412786",
big"2.0358990195749384471803078942778508475105447",
big"2.0438673030416050764938082552508055357536932",
big"2.0518667734879768235699032903388202787086325",
big"2.0598975529764410515311539851427396253726037",
big"2.0679597640471238000138982954032159493019471",
big"2.076053529719759601480774698971190974886495",
big"2.0841789734955686157873760020828031213826762",
big"2.0923362193591411116458702156591367747823646",
big"2.1005253917803293237405302109843070944234469",
big"2.1087466157161467143626575238964185488599182",
big"2.1170000166126746685453698198370956101344916",
big"2.1252857204069766517921478827499607656345219",
big"2.1336038535290198596069082796475876104173024",
big"2.141954542903604388147683817205012365763677",
big"2.1503379159522999554407572913112531245709817",
big"2.1587541005953902027073065862709664584426364",
big"2.1672032252538246054702826653026868576426094",
big"2.1756854188511780242253581730150091331184588",
big"2.1842008108156179245763550154521229783421722",
big"2.1927495310818792968525861728144356991424522",
big"2.2013317100932473053430319197695160332670769",
big"2.2099474788035476974002153710531479045782357",
big"2.2185969686791450027850486355161375002671637",
big"2.2272803117009485537427906566397217584734165",
big"2.2359976403664263564195928556324133682743723",
big"2.2447490876916268443489107954443761003418463",
big"2.2535347872132085448573310784292862413086861",
big"2.2623548729904776893601044121401684567152138",
big"2.2712094796074337986378900692397035812348409",
big"2.2800987421748232743079056783226487661726783",
big"2.2890227963322010278248412694130178222761383",
big"2.2979817782500001784695396251036787167203531",
big"2.3069758246316098519065681271390235943873022",
big"2.3160050727154611110154123174147474653913428",
big"2.32506966027712105082411019794800030841958",
big"2.3341697256313950894987207698035707748063283",
big"2.3433054076344374874670823571053781999975876",
big"2.352476845685870126880867787415201591593135",
big"2.3616841797309095837459864196889344674000366",
big"2.3709275502625025251779192489894964270765329",
big"2.3802070983234694643656048039370752132460841",
big"2.3895229655086569059550222268607428894033582",
big"2.3988752939670979146916457337162967482854659",
big"2.4082642264041811402894735446052064189541318",
big"2.4176899060838283316233663173665756270227349",
big"2.4271524768306803734709670750917334949139414",
big"2.4366520830322918791605185701090931800750108",
big"2.4461888696413343726114469563210060388105308",
big"2.4557629821778080933856445408266406336725324",
big"2.4653745667312624584989612544143600966570358",
big"2.4750237699630252148745063264598957734822349",
big"2.4847107391084403164519704885869968967885934",
big"2.4944356219791145601003068865880476028893769",
big"2.5041985669651730146147577829358268760753641",
big"2.5139997230375232772133861220671538815112637",
big"2.5238392397501285920829681547893051234396304",
big"2.533717267242289865659327631968429446833967",
big"2.5436339562409366134629456444676263089122303",
big"2.5535894580629268734469650775485663612146274",
big"2.5635839246173561209515269431795734112490795",
big"2.5736175084078752204957296405891146914479675",
big"2.5836903625350174497763935698217882499996026",
big"2.5938026406985346313812445890522234238021264",
big"2.6039544971997424078631026762839444413754604",
big"2.6141460869438746959611789503655914445178259",
big"2.6243775654424473558956470538559895767179813",
big"2.6346490888156311118022659383545698498240101",
big"2.6449608137946337595149924670414734811886784",
big"2.6553128977240916980462361132966847731583179",
big"2.6657054985644708212566765507744459129605862",
big"2.676138774894476806349390270046054291415995",
big"2.6866128859134748359664166992354320756243384",
big"2.6971279914439187908098398388318050409222763",
big"2.7076842519337899498539703405097468565320357",
];


julia> function accurateC1C2(C,p=53)
         R3 = FF3(1/C)
         R = sum(BigFloat.(R3))
         C1a = FF3(1/R)
         C1b = map(x->round(x, sigdigits=p-2, base=2), C1a)
         C1 = FF3(sum(BigFloat.(C1b))); C13 = sum(BigFloat.(C1))
         C2a = ((C-C13) / (8*eps(eps(C13)))) * (8*eps(eps(C13)))
         C2 = FF3(C2a)
         return C1, C2
       end
accurateC1C2 (generic function with 2 methods)

julia> accurateC1C2(g)
((1.618033988749895, -5.4321152036825055e-17, 2.6543252083815655e-33), (-6.162975822039155e-33, -3.304991997502108e-50, 6.608118949502031e-67))

julia> function accurateargreduction(x, z, C1, C2)
           u = x - z*C1[1]
           v1 = u - z*C2[1]
           p1,p2 = two_prod(z, C2[1])
           t1,t2 = two_hilo_sum(u, -p1)
           v2 = (((t1-v1)+t2)-p2)
           return v2
       end

=#

#=
   function exp(x)
      signbit(x) && return inv(exp(abs(x))
=#

#=
 function v = exp( v )
            if ~isreal( v )
                [ sin_imag_v, cos_imag_v ] = sincos( imag( v ) );
                v = exp( real( v ) ) .* ( cos_imag_v + 1i .* sin_imag_v );
                return
            end
            
            % Strategy:  We first reduce the size of x by noting that
            % exp(kr + m * log(2)) = 2^m * exp(r)^k
            % where m and k are integers.  By choosing m appropriately
            % we can make |kr| <= log(2) / 2 = 0.347.  Then exp(r) is 
            % evaluated using the familiar Taylor series.  Reducing the 
            % argument substantially speeds up the convergence.
            k = 512.0;
            inv_k = 1.0 / k;
            Threshhold = inv_k .* DoubleDouble.eps.v1;

            m = floor( v.v1 ./ DoubleDouble.log_2.v1 + 0.5 );
            r = TimesPowerOf2( v - DoubleDouble.log_2 .* m, inv_k );

            p = r .* r;
            s = r + TimesPowerOf2( p, 0.5 );
            p = p .* r;
            t = p .* DoubleDouble.Make( DoubleDouble.InverseFactorial( 1, 1 ), DoubleDouble.InverseFactorial( 1, 2 ) );
            for i = 2 : DoubleDouble.NInverseFactorial
                s = s + t;
                p = p .* r;
                t = p .* DoubleDouble.Make( DoubleDouble.InverseFactorial( i, 1 ), DoubleDouble.InverseFactorial( i, 2 ) );
                if all( abs( t.v1(:) ) <= Threshhold )
                    break
                end
            end

            s = s + t;

            s = TimesPowerOf2( s, 2.0 ) + s .* s;
            s = TimesPowerOf2( s, 2.0 ) + s .* s;
            s = TimesPowerOf2( s, 2.0 ) + s .* s;
            s = TimesPowerOf2( s, 2.0 ) + s .* s;
            s = TimesPowerOf2( s, 2.0 ) + s .* s;
            s = TimesPowerOf2( s, 2.0 ) + s .* s;
            s = TimesPowerOf2( s, 2.0 ) + s .* s;
            s = TimesPowerOf2( s, 2.0 ) + s .* s;
            s = TimesPowerOf2( s, 2.0 ) + s .* s;
            s = s + 1.0;
            
            v = DoubleDouble.Make( pow2( s.v1, m ), pow2( s.v2, m ) );
        end

https://github.com/tholden/DoubleDouble/blob/master/DoubleDouble.m
=#
#=
https://www.pseudorandom.com/implementing-exp

def reduced_taylor_exp(x):
    """
    Evaluates f(x) = e^x for any x in the interval [-709, 709].
    If x < -709 or x > 709, raises an assertion error because of
    underflow/overflow limits. Performs a range reduction step
    by applying the identity e^x = e^r * 2^k for |r| <= 1/2 log(2)
    and positive integer k. e^r is approximated using a Taylor series
    truncated at 14 terms, which is enough because e^r is in the
    interval [0, 1/2 log(2)]. The result is left shifted by k
    to obtain e^r * 2^k = e^x.
    Performance: In the worst case we have 51 operations:
    - 16 multiplications
    - 16 divisions
    - 14 additions
    - 2 subtractions
    - 1 rounding
    - 1 left shift
    - 1 absolute value
    Accuracy: Over a sample of 10,000 equi-spaced points in
    [-709, 709] we have the following statistics:
    - Max relative error = 7.98411243625574e-14
    - Min relative error = 0.0
    - Avg relative error = 1.7165594254816366e-14
    - Med relative error = 1.140642685235478e-14
    - Var relative error = 2.964698541882666e-28
    - 6.29 percent of the values have less than 14 digits of precision
    :param x: (int) or (float) power of e to evaluate
    :return: (float) approximation of e^x
    """
    # If x is not a valid value, exit early
    assert(-709 <= x <= 709)
    # If x = 0, we know e^x = 1 so exit early
    if x == 0:
        return 1
    # Normalize x to a positive value since we can use reciprocal
    # symmetry to only work on positive values. Keep track of
    # the original sign for return value
    x0 = np.abs(x)
    # Hard code the value of natural log(2) in double precision
    l = 0.6931471805599453
    # Solve for an integer k satisfying x = k log(2) + r
    k = math.ceil((x0 / l) - 0.5)
    # p = 2^k
    p = 1 << k
    # r is a value between 0 and 0.5 log(2), inclusive
    r = x0 - (k * l)
    # Setup the Taylor series to evaluate e^r after
    # range reduction x -> r. The Taylor series
    # only approximates on the interval [0, log(2)/2]
    Tn = 1
    # We need at most 14 terms to achieve 16 digits
    # of precision anywhere on the interval [0, log(2)/2]
    for i in range(14, 0, -1):
        Tn = Tn * (r / i) + 1
    # e^x = e^r * 2^k, so multiply p by Tn. This loses us
    # about two digits of precision because we compound the
    # relative error by 2^k.
    p *= Tn
    # If the original sign is negative, return reciprocal
    if x < 0:
        p = 1 / p
    return p


double reduced_taylor_exp(double x) {
    /*
     * Evaluates f(x) = e^x for any x in the interval [-709, 709].
     * If x < -709 or x > 709, raises an assertion error. Performs a
     * range reduction step by applying the identity e^x = e^r * 2^k
     * for |r| <= 1/2 log(2) and positive integer k. e^r is evaluated
     * using Taylor series truncated at 14 terms, which is sufficient
     * to achieve 16 digits of precision for r so close to 0. The
     * result is left shifted by k to obtain e^r * 2^k = e^x.
     * Performance: In the worst case we have 51 operations:
     * - 16 multiplications
     * - 16 divisions
     * - 14 additions
     * - 2 subtractions
     * - 1 rounding
     * - 1 left shift
     * - 1 absolute value
     * Accuracy: Over a sample of 10,000 linearly spaced points in
     * [-709, 709], we have the following error statistics:
     * - Max relative error = 7.99528e-14
     * - Min relative error = 0
     * - Avg relative error = 0
     * - Med relative error = 2.27878e-14
     * - Var relative error = 0
     * - 6.4 percent of the values have less than 14 digits of precision.
     * Args:
     *      - x (double float) power of e to evaluate
     * Returns:
     *      - (double float) approximation of e^x
     */
    // Make sure x is a valid input
    assert(-709 <= x && x <= 709);
    // When x is 0, we know e^x is 1
    if (x == 0) {
        return 1;
    }
    // Normalize x to a positive value to take advantage of
    // reciprocal symmetry, but keep track of the original value
    double x0 = abs(x);
    // Solve for k satisfying x = 2^k * log(2) r, with |r| <= 1/2 log(2)
    int k = ceil((x0 / M_LN2) - 0.5);
    // Determine r using the k we computed
    double r = x0 - (k * M_LN2);
    // Setup the Taylor series to evaluate e^r after range reduction
    // x -> r. This only approximates over the interval [0, 1/2 log(2)]
    double tk = 1.0;
    double tn = 1.0;
    // We only need 14 terms to achieve 16 digits of precision for e^r
    for (int i = 1; i < 14; i++) {
        tk *= r / i;
        tn += tk;
    };
    tn = tn * pow2(k);
    if (x < 0) {
        return 1 / tn;
    }
    return tn;
}

=#

#=
kv-master

	friend dd exp(const dd& x) {
		dd x_i, x_f, tmp;
		dd r, y;
		int i;

		if (x == dd(std::numeric_limits<double>::infinity(), 0.)) {
			return dd(std::numeric_limits<double>::infinity(), 0.);
		}
		if (x == -dd(std::numeric_limits<double>::infinity(), 0.)) {
			return (dd)0.;
		}

		if (x >= 0.) {
			x_i = floor(x);
			x_f = x - x_i;
			if (x_f >= 0.5) {
				x_f -= 1.;
				x_i += 1.;
			}
		} else {
			x_i = -floor(-x);
			x_f = x - x_i;
			if (x_f <= -0.5) {
				x_f += 1.;
				x_i -= 1.;
			}
		}

		r = 1.;
		y = 1.;
		for (i=1;  i<=25 ; i++) {
			y *= x_f;
			y /= i;
			r += y;
		}

		if (x_i >= 0.) {
			// r *= pow(constants<dd>::e(), (int)x_i);
			r *= ipower(e(), (double)x_i);
		} else {
			// r /= pow(constants<dd>::e(), -(int)x_i);
			r /= ipower(e(), -(double)x_i);
		}

		return r;
	}

	static dd expm1_origin(const dd& x) {
		dd r, y;
		int i;

		r = 0.;
		y = 1.;
		for (i=1; i<=25 ; i++) {
			y *= x;
			y /= i;
			r += y;
		}

		return r;
	}

	friend dd expm1(const dd& x) {
		if (x >= -0.5 && x <= 0.5) {
			return expm1_origin(x);
		} else {
			return exp(x) - 1.;
		}
	}

=#
