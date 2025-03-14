<p align="justify">
This folder contains the implementation of the use case as <a href="https://link.springer.com/chapter/10.1007/978-3-642-25655-4_14">PROLEG rules</a>. The use case has been implemented within the file <b>regulative+compliance_rules.pl</b>. This file contains both the regulative rules, able to infer which actions of the state of affairs are prohibited, obligatory, or permitted, and the rules for checking compliance of the derived prohibitions and obligations.
</p>

<p align="justify">The file <b>regulative+compliance_rules.pl</b> derives a violation for either all prohibitions that took place in the state of affairs and were not compensated <i>and</i> for all obligations that did not take place in the state of affairs and were not compensated.</p>

<p align="justify">
The state of affairs is described in one of the synthetic datasets (ABox) created by the <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/DatasetGenerator">dataset generator available on this GitHub</a>. Each ABox is a collection of facts describing the states of affairs encoded in PROLEG's input format. Furthermore, since PROLEG is query-based, each ABox has been enriched with all queries that allow to infer a violation from the input facts. A final query "goal" allows to invoke all other queries.
</p>

<p align="justify">
  In order to execute PROLEG, you need to install a Prolog environment such as <a href="https://www.swi-prolog.org">SWI Prolog</a>, the one we used to execute the rules in 
  <b>regulative+compliance_rules.pl</b> on the syntethic datasets. PROLEG is actually the Prolog library <b>prolegEng3.pl</b> that must be loaded before executing the rules.
</p>

<p align="justify">
To run the reasoner, you just run the instructions in the file <b>run.bat</b>. These will first execute the local Java file <b>createProlegRunFile.java</b> that will generate indexed copies of the file <b>regulative+compliance_rules.pl</b> within the subfolder <b>INDEXED_RULES</b> as well as a file <b>run2.bat</b> that will execute the indexed rules one by one.
</p>