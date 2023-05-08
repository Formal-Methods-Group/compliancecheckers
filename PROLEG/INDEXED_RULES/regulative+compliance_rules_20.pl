%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_0 to evaluate the product only with a licence; otherwise, it is prohibited_0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_0 for the licencee to evaluate the product

prohibited_0(Ev) <= evaluate_f_0(Ev), hasAgent_f_0(Ev,X), licensee_f_0(X), hasTheme_f_0(Ev,P), product_f_0(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_0. Art.1b is an exception of Art1.a.
permitted_0(Ev) <= evaluate_f_0(Ev), hasAgent_f_0(Ev,X), licensee_f_0(X), hasTheme_f_0(Ev,P), product_f_0(P), isLicenceOf_f_0(L,P), licence_f_0(L), grant_f_0(Eg), rexist_f_0(Eg), hasTheme_f_0(Eg,L), hasAgent_f_0(Eg,Y), licensor_f_0(Y), hasReceiver_f_0(Eg,X).

exception(prohibited_0(Ev), permitted_0(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_0 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_0. If the licencee publish the results of the evaluation 
% even if this was prohibited_0, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_0 for the licencee to publish the results of the evaluation of the product
prohibited_0(Ep) <= condition_2_0(Ep,X,R).
condition_2_0(Ep,X,R) <= publish_f_0(Ep), hasAgent_f_0(Ep,X), licensee_f_0(X), hasTheme_f_0(Ep,R), result_f_0(R), hasResult_f_0(Ev,R), evaluate_f_0(Ev), rexist_f_0(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_0. Art.2b is an exception of Art2.a.
permitted_0(Ep) <= publish_f_0(Ep), hasAgent_f_0(Ep,X), licensee_f_0(X), hasTheme_f_0(Ep,R), result_f_0(R), hasResult_f_0(Ev,R), evaluate_f_0(Ev), rexist_f_0(Ev), approve_f_0(Ea), rexist_f_0(Ea), hasTheme_f_0(Ea,Ep), licensor_f_0(Y), hasAgent_f_0(Ea,Y).

exception(condition_2_0(Ep,X,R),permitted_0(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_0 to do so, he is obliged to remove them. The removal compensate_0s the violation_0 of the prohibition.
obligatory_0(ca(Ep,X,R)) <= rexist_f_0(Ep), condition_2_0(Ep,X,R).
remove_0(ca(Ep,X,R)) <= rexist_f_0(Ep), condition_2_0(Ep,X,R).
hasTheme_0(ca(Ep,X,R),R) <= rexist_f_0(Ep), condition_2_0(Ep,X,R).
hasAgent_0(ca(Ep,X,R),X) <= rexist_f_0(Ep), condition_2_0(Ep,X,R).
compensate_0(ca(Ep,X,R),Ep) <= rexist_f_0(Ep), condition_2_0(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_0 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_0.
prohibited_0(Ep) <= publish_f_0(Ep), hasAgent_f_0(Ep,X), licensee_f_0(X), hasTheme_f_0(Ep,C), comment_f_0(C), evaluate_f_0(Ev), rexist_f_0(Ev), isCommentOf_f_0(C,Ev).

% Art.3b: if publishing the result is permitted_0, also publishing the comments is permitted_0; this overrides the above prohibition.
permitted_0(Ep) <= publish_f_0(Ep), hasAgent_f_0(Ep,X), licensee_f_0(X), hasTheme_f_0(Ep,C), comment_f_0(C), isCommentOf_f_0(C,Ev), evaluate_f_0(Ev), rexist_f_0(Ev), hasResult_f_0(Ev,R), publish_f_0(Epr), hasAgent_f_0(Epr,X), hasTheme_f_0(Epr,R), permitted_0(Epr).

exception(prohibited_0(Ep),permitted_0(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_0. Art.4a is an exception of Art2.a.

obligatory_0(Ep) <= publish_f_0(Ep), hasAgent_f_0(Ep,X), licensee_f_0(X), hasTheme_f_0(Ep,R), result_f_0(R), hasResult_f_0(Ev,R), evaluate_f_0(Ev), rexist_f_0(Ev), commission_f_0(Ec), rexist_f_0(Ec), hasTheme_f_0(Ec,Ev).
exception(condition_2_0(Ep,X,R),obligatory_0(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_0 action x and, at the same time, x does not really exist => violation_0; 
%(2) if there is some prohibited_0 action x and, at the same time, x really exists => violation_0

rexist_0(ca(Ep,X,R)) <= remove_0(ca(Ep,X,R)), hasAgent_0(ca(Ep,X,R),X), hasTheme_0(ca(Ep,X,R),R), rexist_f_0(Er), remove_f_0(Er), hasTheme_f_0(Er,R), hasAgent_f_0(Er,X).

violation_0(viol(X)) <= obligatory_0(X).
-violation_0(viol(X)) <= obligatory_0(X), rexist_0(X).
exception(violation_0(X),-violation_0(X)).

violation_0(viol(X)) <= prohibited_0(X), rexist_0(X).

referTo_0(viol(X),X) <= violation_0(viol(X)).

compensate_0d_0(X) <= compensate_0(Y,X), rexist_0(Y).
exception(violation_0(viol(X)),compensate_0d_0(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_0(X) <= rexist_f_0(X).
licensee_0(X) <= licensee_f_0(X).
licensor_0(X) <= licensor_f_0(X).
product_0(X) <= product_f_0(X).
result_0(X) <= result_f_0(X).
licence_0(X) <= licence_f_0(X).
comment_0(X) <= comment_f_0(X).
isLicenceOf_0(X,Y) <= isLicenceOf_f_0(X,Y).
                
approve_0(X) <= approve_f_0(X).
commission_0(X) <= commission_f_0(X).
evaluate_0(X) <= evaluate_f_0(X).
grant_0(X) <= grant_f_0(X).
publish_0(X) <= publish_f_0(X).
remove_0(X) <= remove_f_0(X).
                
hasAgent_0(X,Y) <= hasAgent_f_0(X,Y).
hasTheme_0(X,Y) <= hasTheme_f_0(X,Y).
hasResult_0(X,Y) <= hasResult_f_0(X,Y).
hasReceiver_0(X,Y) <= hasReceiver_f_0(X,Y).
isCommentOf_0(X,Y) <= isCommentOf_f_0(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_1 to evaluate the product only with a licence; otherwise, it is prohibited_1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_1 for the licencee to evaluate the product

prohibited_1(Ev) <= evaluate_f_1(Ev), hasAgent_f_1(Ev,X), licensee_f_1(X), hasTheme_f_1(Ev,P), product_f_1(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_1. Art.1b is an exception of Art1.a.
permitted_1(Ev) <= evaluate_f_1(Ev), hasAgent_f_1(Ev,X), licensee_f_1(X), hasTheme_f_1(Ev,P), product_f_1(P), isLicenceOf_f_1(L,P), licence_f_1(L), grant_f_1(Eg), rexist_f_1(Eg), hasTheme_f_1(Eg,L), hasAgent_f_1(Eg,Y), licensor_f_1(Y), hasReceiver_f_1(Eg,X).

exception(prohibited_1(Ev), permitted_1(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_1 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_1. If the licencee publish the results of the evaluation 
% even if this was prohibited_1, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_1 for the licencee to publish the results of the evaluation of the product
prohibited_1(Ep) <= condition_2_1(Ep,X,R).
condition_2_1(Ep,X,R) <= publish_f_1(Ep), hasAgent_f_1(Ep,X), licensee_f_1(X), hasTheme_f_1(Ep,R), result_f_1(R), hasResult_f_1(Ev,R), evaluate_f_1(Ev), rexist_f_1(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_1. Art.2b is an exception of Art2.a.
permitted_1(Ep) <= publish_f_1(Ep), hasAgent_f_1(Ep,X), licensee_f_1(X), hasTheme_f_1(Ep,R), result_f_1(R), hasResult_f_1(Ev,R), evaluate_f_1(Ev), rexist_f_1(Ev), approve_f_1(Ea), rexist_f_1(Ea), hasTheme_f_1(Ea,Ep), licensor_f_1(Y), hasAgent_f_1(Ea,Y).

exception(condition_2_1(Ep,X,R),permitted_1(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_1 to do so, he is obliged to remove them. The removal compensate_1s the violation_1 of the prohibition.
obligatory_1(ca(Ep,X,R)) <= rexist_f_1(Ep), condition_2_1(Ep,X,R).
remove_1(ca(Ep,X,R)) <= rexist_f_1(Ep), condition_2_1(Ep,X,R).
hasTheme_1(ca(Ep,X,R),R) <= rexist_f_1(Ep), condition_2_1(Ep,X,R).
hasAgent_1(ca(Ep,X,R),X) <= rexist_f_1(Ep), condition_2_1(Ep,X,R).
compensate_1(ca(Ep,X,R),Ep) <= rexist_f_1(Ep), condition_2_1(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_1 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_1.
prohibited_1(Ep) <= publish_f_1(Ep), hasAgent_f_1(Ep,X), licensee_f_1(X), hasTheme_f_1(Ep,C), comment_f_1(C), evaluate_f_1(Ev), rexist_f_1(Ev), isCommentOf_f_1(C,Ev).

% Art.3b: if publishing the result is permitted_1, also publishing the comments is permitted_1; this overrides the above prohibition.
permitted_1(Ep) <= publish_f_1(Ep), hasAgent_f_1(Ep,X), licensee_f_1(X), hasTheme_f_1(Ep,C), comment_f_1(C), isCommentOf_f_1(C,Ev), evaluate_f_1(Ev), rexist_f_1(Ev), hasResult_f_1(Ev,R), publish_f_1(Epr), hasAgent_f_1(Epr,X), hasTheme_f_1(Epr,R), permitted_1(Epr).

exception(prohibited_1(Ep),permitted_1(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_1. Art.4a is an exception of Art2.a.

obligatory_1(Ep) <= publish_f_1(Ep), hasAgent_f_1(Ep,X), licensee_f_1(X), hasTheme_f_1(Ep,R), result_f_1(R), hasResult_f_1(Ev,R), evaluate_f_1(Ev), rexist_f_1(Ev), commission_f_1(Ec), rexist_f_1(Ec), hasTheme_f_1(Ec,Ev).
exception(condition_2_1(Ep,X,R),obligatory_1(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_1 action x and, at the same time, x does not really exist => violation_1; 
%(2) if there is some prohibited_1 action x and, at the same time, x really exists => violation_1

rexist_1(ca(Ep,X,R)) <= remove_1(ca(Ep,X,R)), hasAgent_1(ca(Ep,X,R),X), hasTheme_1(ca(Ep,X,R),R), rexist_f_1(Er), remove_f_1(Er), hasTheme_f_1(Er,R), hasAgent_f_1(Er,X).

violation_1(viol(X)) <= obligatory_1(X).
-violation_1(viol(X)) <= obligatory_1(X), rexist_1(X).
exception(violation_1(X),-violation_1(X)).

violation_1(viol(X)) <= prohibited_1(X), rexist_1(X).

referTo_1(viol(X),X) <= violation_1(viol(X)).

compensate_1d_1(X) <= compensate_1(Y,X), rexist_1(Y).
exception(violation_1(viol(X)),compensate_1d_1(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_1(X) <= rexist_f_1(X).
licensee_1(X) <= licensee_f_1(X).
licensor_1(X) <= licensor_f_1(X).
product_1(X) <= product_f_1(X).
result_1(X) <= result_f_1(X).
licence_1(X) <= licence_f_1(X).
comment_1(X) <= comment_f_1(X).
isLicenceOf_1(X,Y) <= isLicenceOf_f_1(X,Y).
                
approve_1(X) <= approve_f_1(X).
commission_1(X) <= commission_f_1(X).
evaluate_1(X) <= evaluate_f_1(X).
grant_1(X) <= grant_f_1(X).
publish_1(X) <= publish_f_1(X).
remove_1(X) <= remove_f_1(X).
                
hasAgent_1(X,Y) <= hasAgent_f_1(X,Y).
hasTheme_1(X,Y) <= hasTheme_f_1(X,Y).
hasResult_1(X,Y) <= hasResult_f_1(X,Y).
hasReceiver_1(X,Y) <= hasReceiver_f_1(X,Y).
isCommentOf_1(X,Y) <= isCommentOf_f_1(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_2 to evaluate the product only with a licence; otherwise, it is prohibited_2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_2 for the licencee to evaluate the product

prohibited_2(Ev) <= evaluate_f_2(Ev), hasAgent_f_2(Ev,X), licensee_f_2(X), hasTheme_f_2(Ev,P), product_f_2(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_2. Art.1b is an exception of Art1.a.
permitted_2(Ev) <= evaluate_f_2(Ev), hasAgent_f_2(Ev,X), licensee_f_2(X), hasTheme_f_2(Ev,P), product_f_2(P), isLicenceOf_f_2(L,P), licence_f_2(L), grant_f_2(Eg), rexist_f_2(Eg), hasTheme_f_2(Eg,L), hasAgent_f_2(Eg,Y), licensor_f_2(Y), hasReceiver_f_2(Eg,X).

exception(prohibited_2(Ev), permitted_2(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_2 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_2. If the licencee publish the results of the evaluation 
% even if this was prohibited_2, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_2 for the licencee to publish the results of the evaluation of the product
prohibited_2(Ep) <= condition_2_2(Ep,X,R).
condition_2_2(Ep,X,R) <= publish_f_2(Ep), hasAgent_f_2(Ep,X), licensee_f_2(X), hasTheme_f_2(Ep,R), result_f_2(R), hasResult_f_2(Ev,R), evaluate_f_2(Ev), rexist_f_2(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_2. Art.2b is an exception of Art2.a.
permitted_2(Ep) <= publish_f_2(Ep), hasAgent_f_2(Ep,X), licensee_f_2(X), hasTheme_f_2(Ep,R), result_f_2(R), hasResult_f_2(Ev,R), evaluate_f_2(Ev), rexist_f_2(Ev), approve_f_2(Ea), rexist_f_2(Ea), hasTheme_f_2(Ea,Ep), licensor_f_2(Y), hasAgent_f_2(Ea,Y).

exception(condition_2_2(Ep,X,R),permitted_2(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_2 to do so, he is obliged to remove them. The removal compensate_2s the violation_2 of the prohibition.
obligatory_2(ca(Ep,X,R)) <= rexist_f_2(Ep), condition_2_2(Ep,X,R).
remove_2(ca(Ep,X,R)) <= rexist_f_2(Ep), condition_2_2(Ep,X,R).
hasTheme_2(ca(Ep,X,R),R) <= rexist_f_2(Ep), condition_2_2(Ep,X,R).
hasAgent_2(ca(Ep,X,R),X) <= rexist_f_2(Ep), condition_2_2(Ep,X,R).
compensate_2(ca(Ep,X,R),Ep) <= rexist_f_2(Ep), condition_2_2(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_2 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_2.
prohibited_2(Ep) <= publish_f_2(Ep), hasAgent_f_2(Ep,X), licensee_f_2(X), hasTheme_f_2(Ep,C), comment_f_2(C), evaluate_f_2(Ev), rexist_f_2(Ev), isCommentOf_f_2(C,Ev).

% Art.3b: if publishing the result is permitted_2, also publishing the comments is permitted_2; this overrides the above prohibition.
permitted_2(Ep) <= publish_f_2(Ep), hasAgent_f_2(Ep,X), licensee_f_2(X), hasTheme_f_2(Ep,C), comment_f_2(C), isCommentOf_f_2(C,Ev), evaluate_f_2(Ev), rexist_f_2(Ev), hasResult_f_2(Ev,R), publish_f_2(Epr), hasAgent_f_2(Epr,X), hasTheme_f_2(Epr,R), permitted_2(Epr).

exception(prohibited_2(Ep),permitted_2(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_2. Art.4a is an exception of Art2.a.

obligatory_2(Ep) <= publish_f_2(Ep), hasAgent_f_2(Ep,X), licensee_f_2(X), hasTheme_f_2(Ep,R), result_f_2(R), hasResult_f_2(Ev,R), evaluate_f_2(Ev), rexist_f_2(Ev), commission_f_2(Ec), rexist_f_2(Ec), hasTheme_f_2(Ec,Ev).
exception(condition_2_2(Ep,X,R),obligatory_2(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_2 action x and, at the same time, x does not really exist => violation_2; 
%(2) if there is some prohibited_2 action x and, at the same time, x really exists => violation_2

rexist_2(ca(Ep,X,R)) <= remove_2(ca(Ep,X,R)), hasAgent_2(ca(Ep,X,R),X), hasTheme_2(ca(Ep,X,R),R), rexist_f_2(Er), remove_f_2(Er), hasTheme_f_2(Er,R), hasAgent_f_2(Er,X).

violation_2(viol(X)) <= obligatory_2(X).
-violation_2(viol(X)) <= obligatory_2(X), rexist_2(X).
exception(violation_2(X),-violation_2(X)).

violation_2(viol(X)) <= prohibited_2(X), rexist_2(X).

referTo_2(viol(X),X) <= violation_2(viol(X)).

compensate_2d_2(X) <= compensate_2(Y,X), rexist_2(Y).
exception(violation_2(viol(X)),compensate_2d_2(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_2(X) <= rexist_f_2(X).
licensee_2(X) <= licensee_f_2(X).
licensor_2(X) <= licensor_f_2(X).
product_2(X) <= product_f_2(X).
result_2(X) <= result_f_2(X).
licence_2(X) <= licence_f_2(X).
comment_2(X) <= comment_f_2(X).
isLicenceOf_2(X,Y) <= isLicenceOf_f_2(X,Y).
                
approve_2(X) <= approve_f_2(X).
commission_2(X) <= commission_f_2(X).
evaluate_2(X) <= evaluate_f_2(X).
grant_2(X) <= grant_f_2(X).
publish_2(X) <= publish_f_2(X).
remove_2(X) <= remove_f_2(X).
                
hasAgent_2(X,Y) <= hasAgent_f_2(X,Y).
hasTheme_2(X,Y) <= hasTheme_f_2(X,Y).
hasResult_2(X,Y) <= hasResult_f_2(X,Y).
hasReceiver_2(X,Y) <= hasReceiver_f_2(X,Y).
isCommentOf_2(X,Y) <= isCommentOf_f_2(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_3 to evaluate the product only with a licence; otherwise, it is prohibited_3.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_3 for the licencee to evaluate the product

prohibited_3(Ev) <= evaluate_f_3(Ev), hasAgent_f_3(Ev,X), licensee_f_3(X), hasTheme_f_3(Ev,P), product_f_3(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_3. Art.1b is an exception of Art1.a.
permitted_3(Ev) <= evaluate_f_3(Ev), hasAgent_f_3(Ev,X), licensee_f_3(X), hasTheme_f_3(Ev,P), product_f_3(P), isLicenceOf_f_3(L,P), licence_f_3(L), grant_f_3(Eg), rexist_f_3(Eg), hasTheme_f_3(Eg,L), hasAgent_f_3(Eg,Y), licensor_f_3(Y), hasReceiver_f_3(Eg,X).

exception(prohibited_3(Ev), permitted_3(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_3 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_3. If the licencee publish the results of the evaluation 
% even if this was prohibited_3, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_3 for the licencee to publish the results of the evaluation of the product
prohibited_3(Ep) <= condition_2_3(Ep,X,R).
condition_2_3(Ep,X,R) <= publish_f_3(Ep), hasAgent_f_3(Ep,X), licensee_f_3(X), hasTheme_f_3(Ep,R), result_f_3(R), hasResult_f_3(Ev,R), evaluate_f_3(Ev), rexist_f_3(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_3. Art.2b is an exception of Art2.a.
permitted_3(Ep) <= publish_f_3(Ep), hasAgent_f_3(Ep,X), licensee_f_3(X), hasTheme_f_3(Ep,R), result_f_3(R), hasResult_f_3(Ev,R), evaluate_f_3(Ev), rexist_f_3(Ev), approve_f_3(Ea), rexist_f_3(Ea), hasTheme_f_3(Ea,Ep), licensor_f_3(Y), hasAgent_f_3(Ea,Y).

exception(condition_2_3(Ep,X,R),permitted_3(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_3 to do so, he is obliged to remove them. The removal compensate_3s the violation_3 of the prohibition.
obligatory_3(ca(Ep,X,R)) <= rexist_f_3(Ep), condition_2_3(Ep,X,R).
remove_3(ca(Ep,X,R)) <= rexist_f_3(Ep), condition_2_3(Ep,X,R).
hasTheme_3(ca(Ep,X,R),R) <= rexist_f_3(Ep), condition_2_3(Ep,X,R).
hasAgent_3(ca(Ep,X,R),X) <= rexist_f_3(Ep), condition_2_3(Ep,X,R).
compensate_3(ca(Ep,X,R),Ep) <= rexist_f_3(Ep), condition_2_3(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_3 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_3.
prohibited_3(Ep) <= publish_f_3(Ep), hasAgent_f_3(Ep,X), licensee_f_3(X), hasTheme_f_3(Ep,C), comment_f_3(C), evaluate_f_3(Ev), rexist_f_3(Ev), isCommentOf_f_3(C,Ev).

% Art.3b: if publishing the result is permitted_3, also publishing the comments is permitted_3; this overrides the above prohibition.
permitted_3(Ep) <= publish_f_3(Ep), hasAgent_f_3(Ep,X), licensee_f_3(X), hasTheme_f_3(Ep,C), comment_f_3(C), isCommentOf_f_3(C,Ev), evaluate_f_3(Ev), rexist_f_3(Ev), hasResult_f_3(Ev,R), publish_f_3(Epr), hasAgent_f_3(Epr,X), hasTheme_f_3(Epr,R), permitted_3(Epr).

exception(prohibited_3(Ep),permitted_3(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_3. Art.4a is an exception of Art2.a.

obligatory_3(Ep) <= publish_f_3(Ep), hasAgent_f_3(Ep,X), licensee_f_3(X), hasTheme_f_3(Ep,R), result_f_3(R), hasResult_f_3(Ev,R), evaluate_f_3(Ev), rexist_f_3(Ev), commission_f_3(Ec), rexist_f_3(Ec), hasTheme_f_3(Ec,Ev).
exception(condition_2_3(Ep,X,R),obligatory_3(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_3 action x and, at the same time, x does not really exist => violation_3; 
%(2) if there is some prohibited_3 action x and, at the same time, x really exists => violation_3

rexist_3(ca(Ep,X,R)) <= remove_3(ca(Ep,X,R)), hasAgent_3(ca(Ep,X,R),X), hasTheme_3(ca(Ep,X,R),R), rexist_f_3(Er), remove_f_3(Er), hasTheme_f_3(Er,R), hasAgent_f_3(Er,X).

violation_3(viol(X)) <= obligatory_3(X).
-violation_3(viol(X)) <= obligatory_3(X), rexist_3(X).
exception(violation_3(X),-violation_3(X)).

violation_3(viol(X)) <= prohibited_3(X), rexist_3(X).

referTo_3(viol(X),X) <= violation_3(viol(X)).

compensate_3d_3(X) <= compensate_3(Y,X), rexist_3(Y).
exception(violation_3(viol(X)),compensate_3d_3(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_3(X) <= rexist_f_3(X).
licensee_3(X) <= licensee_f_3(X).
licensor_3(X) <= licensor_f_3(X).
product_3(X) <= product_f_3(X).
result_3(X) <= result_f_3(X).
licence_3(X) <= licence_f_3(X).
comment_3(X) <= comment_f_3(X).
isLicenceOf_3(X,Y) <= isLicenceOf_f_3(X,Y).
                
approve_3(X) <= approve_f_3(X).
commission_3(X) <= commission_f_3(X).
evaluate_3(X) <= evaluate_f_3(X).
grant_3(X) <= grant_f_3(X).
publish_3(X) <= publish_f_3(X).
remove_3(X) <= remove_f_3(X).
                
hasAgent_3(X,Y) <= hasAgent_f_3(X,Y).
hasTheme_3(X,Y) <= hasTheme_f_3(X,Y).
hasResult_3(X,Y) <= hasResult_f_3(X,Y).
hasReceiver_3(X,Y) <= hasReceiver_f_3(X,Y).
isCommentOf_3(X,Y) <= isCommentOf_f_3(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_4 to evaluate the product only with a licence; otherwise, it is prohibited_4.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_4 for the licencee to evaluate the product

prohibited_4(Ev) <= evaluate_f_4(Ev), hasAgent_f_4(Ev,X), licensee_f_4(X), hasTheme_f_4(Ev,P), product_f_4(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_4. Art.1b is an exception of Art1.a.
permitted_4(Ev) <= evaluate_f_4(Ev), hasAgent_f_4(Ev,X), licensee_f_4(X), hasTheme_f_4(Ev,P), product_f_4(P), isLicenceOf_f_4(L,P), licence_f_4(L), grant_f_4(Eg), rexist_f_4(Eg), hasTheme_f_4(Eg,L), hasAgent_f_4(Eg,Y), licensor_f_4(Y), hasReceiver_f_4(Eg,X).

exception(prohibited_4(Ev), permitted_4(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_4 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_4. If the licencee publish the results of the evaluation 
% even if this was prohibited_4, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_4 for the licencee to publish the results of the evaluation of the product
prohibited_4(Ep) <= condition_2_4(Ep,X,R).
condition_2_4(Ep,X,R) <= publish_f_4(Ep), hasAgent_f_4(Ep,X), licensee_f_4(X), hasTheme_f_4(Ep,R), result_f_4(R), hasResult_f_4(Ev,R), evaluate_f_4(Ev), rexist_f_4(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_4. Art.2b is an exception of Art2.a.
permitted_4(Ep) <= publish_f_4(Ep), hasAgent_f_4(Ep,X), licensee_f_4(X), hasTheme_f_4(Ep,R), result_f_4(R), hasResult_f_4(Ev,R), evaluate_f_4(Ev), rexist_f_4(Ev), approve_f_4(Ea), rexist_f_4(Ea), hasTheme_f_4(Ea,Ep), licensor_f_4(Y), hasAgent_f_4(Ea,Y).

exception(condition_2_4(Ep,X,R),permitted_4(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_4 to do so, he is obliged to remove them. The removal compensate_4s the violation_4 of the prohibition.
obligatory_4(ca(Ep,X,R)) <= rexist_f_4(Ep), condition_2_4(Ep,X,R).
remove_4(ca(Ep,X,R)) <= rexist_f_4(Ep), condition_2_4(Ep,X,R).
hasTheme_4(ca(Ep,X,R),R) <= rexist_f_4(Ep), condition_2_4(Ep,X,R).
hasAgent_4(ca(Ep,X,R),X) <= rexist_f_4(Ep), condition_2_4(Ep,X,R).
compensate_4(ca(Ep,X,R),Ep) <= rexist_f_4(Ep), condition_2_4(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_4 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_4.
prohibited_4(Ep) <= publish_f_4(Ep), hasAgent_f_4(Ep,X), licensee_f_4(X), hasTheme_f_4(Ep,C), comment_f_4(C), evaluate_f_4(Ev), rexist_f_4(Ev), isCommentOf_f_4(C,Ev).

% Art.3b: if publishing the result is permitted_4, also publishing the comments is permitted_4; this overrides the above prohibition.
permitted_4(Ep) <= publish_f_4(Ep), hasAgent_f_4(Ep,X), licensee_f_4(X), hasTheme_f_4(Ep,C), comment_f_4(C), isCommentOf_f_4(C,Ev), evaluate_f_4(Ev), rexist_f_4(Ev), hasResult_f_4(Ev,R), publish_f_4(Epr), hasAgent_f_4(Epr,X), hasTheme_f_4(Epr,R), permitted_4(Epr).

exception(prohibited_4(Ep),permitted_4(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_4. Art.4a is an exception of Art2.a.

obligatory_4(Ep) <= publish_f_4(Ep), hasAgent_f_4(Ep,X), licensee_f_4(X), hasTheme_f_4(Ep,R), result_f_4(R), hasResult_f_4(Ev,R), evaluate_f_4(Ev), rexist_f_4(Ev), commission_f_4(Ec), rexist_f_4(Ec), hasTheme_f_4(Ec,Ev).
exception(condition_2_4(Ep,X,R),obligatory_4(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_4 action x and, at the same time, x does not really exist => violation_4; 
%(2) if there is some prohibited_4 action x and, at the same time, x really exists => violation_4

rexist_4(ca(Ep,X,R)) <= remove_4(ca(Ep,X,R)), hasAgent_4(ca(Ep,X,R),X), hasTheme_4(ca(Ep,X,R),R), rexist_f_4(Er), remove_f_4(Er), hasTheme_f_4(Er,R), hasAgent_f_4(Er,X).

violation_4(viol(X)) <= obligatory_4(X).
-violation_4(viol(X)) <= obligatory_4(X), rexist_4(X).
exception(violation_4(X),-violation_4(X)).

violation_4(viol(X)) <= prohibited_4(X), rexist_4(X).

referTo_4(viol(X),X) <= violation_4(viol(X)).

compensate_4d_4(X) <= compensate_4(Y,X), rexist_4(Y).
exception(violation_4(viol(X)),compensate_4d_4(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_4(X) <= rexist_f_4(X).
licensee_4(X) <= licensee_f_4(X).
licensor_4(X) <= licensor_f_4(X).
product_4(X) <= product_f_4(X).
result_4(X) <= result_f_4(X).
licence_4(X) <= licence_f_4(X).
comment_4(X) <= comment_f_4(X).
isLicenceOf_4(X,Y) <= isLicenceOf_f_4(X,Y).
                
approve_4(X) <= approve_f_4(X).
commission_4(X) <= commission_f_4(X).
evaluate_4(X) <= evaluate_f_4(X).
grant_4(X) <= grant_f_4(X).
publish_4(X) <= publish_f_4(X).
remove_4(X) <= remove_f_4(X).
                
hasAgent_4(X,Y) <= hasAgent_f_4(X,Y).
hasTheme_4(X,Y) <= hasTheme_f_4(X,Y).
hasResult_4(X,Y) <= hasResult_f_4(X,Y).
hasReceiver_4(X,Y) <= hasReceiver_f_4(X,Y).
isCommentOf_4(X,Y) <= isCommentOf_f_4(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_5 to evaluate the product only with a licence; otherwise, it is prohibited_5.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_5 for the licencee to evaluate the product

prohibited_5(Ev) <= evaluate_f_5(Ev), hasAgent_f_5(Ev,X), licensee_f_5(X), hasTheme_f_5(Ev,P), product_f_5(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_5. Art.1b is an exception of Art1.a.
permitted_5(Ev) <= evaluate_f_5(Ev), hasAgent_f_5(Ev,X), licensee_f_5(X), hasTheme_f_5(Ev,P), product_f_5(P), isLicenceOf_f_5(L,P), licence_f_5(L), grant_f_5(Eg), rexist_f_5(Eg), hasTheme_f_5(Eg,L), hasAgent_f_5(Eg,Y), licensor_f_5(Y), hasReceiver_f_5(Eg,X).

exception(prohibited_5(Ev), permitted_5(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_5 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_5. If the licencee publish the results of the evaluation 
% even if this was prohibited_5, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_5 for the licencee to publish the results of the evaluation of the product
prohibited_5(Ep) <= condition_2_5(Ep,X,R).
condition_2_5(Ep,X,R) <= publish_f_5(Ep), hasAgent_f_5(Ep,X), licensee_f_5(X), hasTheme_f_5(Ep,R), result_f_5(R), hasResult_f_5(Ev,R), evaluate_f_5(Ev), rexist_f_5(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_5. Art.2b is an exception of Art2.a.
permitted_5(Ep) <= publish_f_5(Ep), hasAgent_f_5(Ep,X), licensee_f_5(X), hasTheme_f_5(Ep,R), result_f_5(R), hasResult_f_5(Ev,R), evaluate_f_5(Ev), rexist_f_5(Ev), approve_f_5(Ea), rexist_f_5(Ea), hasTheme_f_5(Ea,Ep), licensor_f_5(Y), hasAgent_f_5(Ea,Y).

exception(condition_2_5(Ep,X,R),permitted_5(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_5 to do so, he is obliged to remove them. The removal compensate_5s the violation_5 of the prohibition.
obligatory_5(ca(Ep,X,R)) <= rexist_f_5(Ep), condition_2_5(Ep,X,R).
remove_5(ca(Ep,X,R)) <= rexist_f_5(Ep), condition_2_5(Ep,X,R).
hasTheme_5(ca(Ep,X,R),R) <= rexist_f_5(Ep), condition_2_5(Ep,X,R).
hasAgent_5(ca(Ep,X,R),X) <= rexist_f_5(Ep), condition_2_5(Ep,X,R).
compensate_5(ca(Ep,X,R),Ep) <= rexist_f_5(Ep), condition_2_5(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_5 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_5.
prohibited_5(Ep) <= publish_f_5(Ep), hasAgent_f_5(Ep,X), licensee_f_5(X), hasTheme_f_5(Ep,C), comment_f_5(C), evaluate_f_5(Ev), rexist_f_5(Ev), isCommentOf_f_5(C,Ev).

% Art.3b: if publishing the result is permitted_5, also publishing the comments is permitted_5; this overrides the above prohibition.
permitted_5(Ep) <= publish_f_5(Ep), hasAgent_f_5(Ep,X), licensee_f_5(X), hasTheme_f_5(Ep,C), comment_f_5(C), isCommentOf_f_5(C,Ev), evaluate_f_5(Ev), rexist_f_5(Ev), hasResult_f_5(Ev,R), publish_f_5(Epr), hasAgent_f_5(Epr,X), hasTheme_f_5(Epr,R), permitted_5(Epr).

exception(prohibited_5(Ep),permitted_5(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_5. Art.4a is an exception of Art2.a.

obligatory_5(Ep) <= publish_f_5(Ep), hasAgent_f_5(Ep,X), licensee_f_5(X), hasTheme_f_5(Ep,R), result_f_5(R), hasResult_f_5(Ev,R), evaluate_f_5(Ev), rexist_f_5(Ev), commission_f_5(Ec), rexist_f_5(Ec), hasTheme_f_5(Ec,Ev).
exception(condition_2_5(Ep,X,R),obligatory_5(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_5 action x and, at the same time, x does not really exist => violation_5; 
%(2) if there is some prohibited_5 action x and, at the same time, x really exists => violation_5

rexist_5(ca(Ep,X,R)) <= remove_5(ca(Ep,X,R)), hasAgent_5(ca(Ep,X,R),X), hasTheme_5(ca(Ep,X,R),R), rexist_f_5(Er), remove_f_5(Er), hasTheme_f_5(Er,R), hasAgent_f_5(Er,X).

violation_5(viol(X)) <= obligatory_5(X).
-violation_5(viol(X)) <= obligatory_5(X), rexist_5(X).
exception(violation_5(X),-violation_5(X)).

violation_5(viol(X)) <= prohibited_5(X), rexist_5(X).

referTo_5(viol(X),X) <= violation_5(viol(X)).

compensate_5d_5(X) <= compensate_5(Y,X), rexist_5(Y).
exception(violation_5(viol(X)),compensate_5d_5(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_5(X) <= rexist_f_5(X).
licensee_5(X) <= licensee_f_5(X).
licensor_5(X) <= licensor_f_5(X).
product_5(X) <= product_f_5(X).
result_5(X) <= result_f_5(X).
licence_5(X) <= licence_f_5(X).
comment_5(X) <= comment_f_5(X).
isLicenceOf_5(X,Y) <= isLicenceOf_f_5(X,Y).
                
approve_5(X) <= approve_f_5(X).
commission_5(X) <= commission_f_5(X).
evaluate_5(X) <= evaluate_f_5(X).
grant_5(X) <= grant_f_5(X).
publish_5(X) <= publish_f_5(X).
remove_5(X) <= remove_f_5(X).
                
hasAgent_5(X,Y) <= hasAgent_f_5(X,Y).
hasTheme_5(X,Y) <= hasTheme_f_5(X,Y).
hasResult_5(X,Y) <= hasResult_f_5(X,Y).
hasReceiver_5(X,Y) <= hasReceiver_f_5(X,Y).
isCommentOf_5(X,Y) <= isCommentOf_f_5(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_6 to evaluate the product only with a licence; otherwise, it is prohibited_6.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_6 for the licencee to evaluate the product

prohibited_6(Ev) <= evaluate_f_6(Ev), hasAgent_f_6(Ev,X), licensee_f_6(X), hasTheme_f_6(Ev,P), product_f_6(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_6. Art.1b is an exception of Art1.a.
permitted_6(Ev) <= evaluate_f_6(Ev), hasAgent_f_6(Ev,X), licensee_f_6(X), hasTheme_f_6(Ev,P), product_f_6(P), isLicenceOf_f_6(L,P), licence_f_6(L), grant_f_6(Eg), rexist_f_6(Eg), hasTheme_f_6(Eg,L), hasAgent_f_6(Eg,Y), licensor_f_6(Y), hasReceiver_f_6(Eg,X).

exception(prohibited_6(Ev), permitted_6(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_6 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_6. If the licencee publish the results of the evaluation 
% even if this was prohibited_6, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_6 for the licencee to publish the results of the evaluation of the product
prohibited_6(Ep) <= condition_2_6(Ep,X,R).
condition_2_6(Ep,X,R) <= publish_f_6(Ep), hasAgent_f_6(Ep,X), licensee_f_6(X), hasTheme_f_6(Ep,R), result_f_6(R), hasResult_f_6(Ev,R), evaluate_f_6(Ev), rexist_f_6(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_6. Art.2b is an exception of Art2.a.
permitted_6(Ep) <= publish_f_6(Ep), hasAgent_f_6(Ep,X), licensee_f_6(X), hasTheme_f_6(Ep,R), result_f_6(R), hasResult_f_6(Ev,R), evaluate_f_6(Ev), rexist_f_6(Ev), approve_f_6(Ea), rexist_f_6(Ea), hasTheme_f_6(Ea,Ep), licensor_f_6(Y), hasAgent_f_6(Ea,Y).

exception(condition_2_6(Ep,X,R),permitted_6(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_6 to do so, he is obliged to remove them. The removal compensate_6s the violation_6 of the prohibition.
obligatory_6(ca(Ep,X,R)) <= rexist_f_6(Ep), condition_2_6(Ep,X,R).
remove_6(ca(Ep,X,R)) <= rexist_f_6(Ep), condition_2_6(Ep,X,R).
hasTheme_6(ca(Ep,X,R),R) <= rexist_f_6(Ep), condition_2_6(Ep,X,R).
hasAgent_6(ca(Ep,X,R),X) <= rexist_f_6(Ep), condition_2_6(Ep,X,R).
compensate_6(ca(Ep,X,R),Ep) <= rexist_f_6(Ep), condition_2_6(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_6 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_6.
prohibited_6(Ep) <= publish_f_6(Ep), hasAgent_f_6(Ep,X), licensee_f_6(X), hasTheme_f_6(Ep,C), comment_f_6(C), evaluate_f_6(Ev), rexist_f_6(Ev), isCommentOf_f_6(C,Ev).

% Art.3b: if publishing the result is permitted_6, also publishing the comments is permitted_6; this overrides the above prohibition.
permitted_6(Ep) <= publish_f_6(Ep), hasAgent_f_6(Ep,X), licensee_f_6(X), hasTheme_f_6(Ep,C), comment_f_6(C), isCommentOf_f_6(C,Ev), evaluate_f_6(Ev), rexist_f_6(Ev), hasResult_f_6(Ev,R), publish_f_6(Epr), hasAgent_f_6(Epr,X), hasTheme_f_6(Epr,R), permitted_6(Epr).

exception(prohibited_6(Ep),permitted_6(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_6. Art.4a is an exception of Art2.a.

obligatory_6(Ep) <= publish_f_6(Ep), hasAgent_f_6(Ep,X), licensee_f_6(X), hasTheme_f_6(Ep,R), result_f_6(R), hasResult_f_6(Ev,R), evaluate_f_6(Ev), rexist_f_6(Ev), commission_f_6(Ec), rexist_f_6(Ec), hasTheme_f_6(Ec,Ev).
exception(condition_2_6(Ep,X,R),obligatory_6(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_6 action x and, at the same time, x does not really exist => violation_6; 
%(2) if there is some prohibited_6 action x and, at the same time, x really exists => violation_6

rexist_6(ca(Ep,X,R)) <= remove_6(ca(Ep,X,R)), hasAgent_6(ca(Ep,X,R),X), hasTheme_6(ca(Ep,X,R),R), rexist_f_6(Er), remove_f_6(Er), hasTheme_f_6(Er,R), hasAgent_f_6(Er,X).

violation_6(viol(X)) <= obligatory_6(X).
-violation_6(viol(X)) <= obligatory_6(X), rexist_6(X).
exception(violation_6(X),-violation_6(X)).

violation_6(viol(X)) <= prohibited_6(X), rexist_6(X).

referTo_6(viol(X),X) <= violation_6(viol(X)).

compensate_6d_6(X) <= compensate_6(Y,X), rexist_6(Y).
exception(violation_6(viol(X)),compensate_6d_6(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_6(X) <= rexist_f_6(X).
licensee_6(X) <= licensee_f_6(X).
licensor_6(X) <= licensor_f_6(X).
product_6(X) <= product_f_6(X).
result_6(X) <= result_f_6(X).
licence_6(X) <= licence_f_6(X).
comment_6(X) <= comment_f_6(X).
isLicenceOf_6(X,Y) <= isLicenceOf_f_6(X,Y).
                
approve_6(X) <= approve_f_6(X).
commission_6(X) <= commission_f_6(X).
evaluate_6(X) <= evaluate_f_6(X).
grant_6(X) <= grant_f_6(X).
publish_6(X) <= publish_f_6(X).
remove_6(X) <= remove_f_6(X).
                
hasAgent_6(X,Y) <= hasAgent_f_6(X,Y).
hasTheme_6(X,Y) <= hasTheme_f_6(X,Y).
hasResult_6(X,Y) <= hasResult_f_6(X,Y).
hasReceiver_6(X,Y) <= hasReceiver_f_6(X,Y).
isCommentOf_6(X,Y) <= isCommentOf_f_6(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_7 to evaluate the product only with a licence; otherwise, it is prohibited_7.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_7 for the licencee to evaluate the product

prohibited_7(Ev) <= evaluate_f_7(Ev), hasAgent_f_7(Ev,X), licensee_f_7(X), hasTheme_f_7(Ev,P), product_f_7(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_7. Art.1b is an exception of Art1.a.
permitted_7(Ev) <= evaluate_f_7(Ev), hasAgent_f_7(Ev,X), licensee_f_7(X), hasTheme_f_7(Ev,P), product_f_7(P), isLicenceOf_f_7(L,P), licence_f_7(L), grant_f_7(Eg), rexist_f_7(Eg), hasTheme_f_7(Eg,L), hasAgent_f_7(Eg,Y), licensor_f_7(Y), hasReceiver_f_7(Eg,X).

exception(prohibited_7(Ev), permitted_7(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_7 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_7. If the licencee publish the results of the evaluation 
% even if this was prohibited_7, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_7 for the licencee to publish the results of the evaluation of the product
prohibited_7(Ep) <= condition_2_7(Ep,X,R).
condition_2_7(Ep,X,R) <= publish_f_7(Ep), hasAgent_f_7(Ep,X), licensee_f_7(X), hasTheme_f_7(Ep,R), result_f_7(R), hasResult_f_7(Ev,R), evaluate_f_7(Ev), rexist_f_7(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_7. Art.2b is an exception of Art2.a.
permitted_7(Ep) <= publish_f_7(Ep), hasAgent_f_7(Ep,X), licensee_f_7(X), hasTheme_f_7(Ep,R), result_f_7(R), hasResult_f_7(Ev,R), evaluate_f_7(Ev), rexist_f_7(Ev), approve_f_7(Ea), rexist_f_7(Ea), hasTheme_f_7(Ea,Ep), licensor_f_7(Y), hasAgent_f_7(Ea,Y).

exception(condition_2_7(Ep,X,R),permitted_7(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_7 to do so, he is obliged to remove them. The removal compensate_7s the violation_7 of the prohibition.
obligatory_7(ca(Ep,X,R)) <= rexist_f_7(Ep), condition_2_7(Ep,X,R).
remove_7(ca(Ep,X,R)) <= rexist_f_7(Ep), condition_2_7(Ep,X,R).
hasTheme_7(ca(Ep,X,R),R) <= rexist_f_7(Ep), condition_2_7(Ep,X,R).
hasAgent_7(ca(Ep,X,R),X) <= rexist_f_7(Ep), condition_2_7(Ep,X,R).
compensate_7(ca(Ep,X,R),Ep) <= rexist_f_7(Ep), condition_2_7(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_7 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_7.
prohibited_7(Ep) <= publish_f_7(Ep), hasAgent_f_7(Ep,X), licensee_f_7(X), hasTheme_f_7(Ep,C), comment_f_7(C), evaluate_f_7(Ev), rexist_f_7(Ev), isCommentOf_f_7(C,Ev).

% Art.3b: if publishing the result is permitted_7, also publishing the comments is permitted_7; this overrides the above prohibition.
permitted_7(Ep) <= publish_f_7(Ep), hasAgent_f_7(Ep,X), licensee_f_7(X), hasTheme_f_7(Ep,C), comment_f_7(C), isCommentOf_f_7(C,Ev), evaluate_f_7(Ev), rexist_f_7(Ev), hasResult_f_7(Ev,R), publish_f_7(Epr), hasAgent_f_7(Epr,X), hasTheme_f_7(Epr,R), permitted_7(Epr).

exception(prohibited_7(Ep),permitted_7(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_7. Art.4a is an exception of Art2.a.

obligatory_7(Ep) <= publish_f_7(Ep), hasAgent_f_7(Ep,X), licensee_f_7(X), hasTheme_f_7(Ep,R), result_f_7(R), hasResult_f_7(Ev,R), evaluate_f_7(Ev), rexist_f_7(Ev), commission_f_7(Ec), rexist_f_7(Ec), hasTheme_f_7(Ec,Ev).
exception(condition_2_7(Ep,X,R),obligatory_7(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_7 action x and, at the same time, x does not really exist => violation_7; 
%(2) if there is some prohibited_7 action x and, at the same time, x really exists => violation_7

rexist_7(ca(Ep,X,R)) <= remove_7(ca(Ep,X,R)), hasAgent_7(ca(Ep,X,R),X), hasTheme_7(ca(Ep,X,R),R), rexist_f_7(Er), remove_f_7(Er), hasTheme_f_7(Er,R), hasAgent_f_7(Er,X).

violation_7(viol(X)) <= obligatory_7(X).
-violation_7(viol(X)) <= obligatory_7(X), rexist_7(X).
exception(violation_7(X),-violation_7(X)).

violation_7(viol(X)) <= prohibited_7(X), rexist_7(X).

referTo_7(viol(X),X) <= violation_7(viol(X)).

compensate_7d_7(X) <= compensate_7(Y,X), rexist_7(Y).
exception(violation_7(viol(X)),compensate_7d_7(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_7(X) <= rexist_f_7(X).
licensee_7(X) <= licensee_f_7(X).
licensor_7(X) <= licensor_f_7(X).
product_7(X) <= product_f_7(X).
result_7(X) <= result_f_7(X).
licence_7(X) <= licence_f_7(X).
comment_7(X) <= comment_f_7(X).
isLicenceOf_7(X,Y) <= isLicenceOf_f_7(X,Y).
                
approve_7(X) <= approve_f_7(X).
commission_7(X) <= commission_f_7(X).
evaluate_7(X) <= evaluate_f_7(X).
grant_7(X) <= grant_f_7(X).
publish_7(X) <= publish_f_7(X).
remove_7(X) <= remove_f_7(X).
                
hasAgent_7(X,Y) <= hasAgent_f_7(X,Y).
hasTheme_7(X,Y) <= hasTheme_f_7(X,Y).
hasResult_7(X,Y) <= hasResult_f_7(X,Y).
hasReceiver_7(X,Y) <= hasReceiver_f_7(X,Y).
isCommentOf_7(X,Y) <= isCommentOf_f_7(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_8 to evaluate the product only with a licence; otherwise, it is prohibited_8.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_8 for the licencee to evaluate the product

prohibited_8(Ev) <= evaluate_f_8(Ev), hasAgent_f_8(Ev,X), licensee_f_8(X), hasTheme_f_8(Ev,P), product_f_8(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_8. Art.1b is an exception of Art1.a.
permitted_8(Ev) <= evaluate_f_8(Ev), hasAgent_f_8(Ev,X), licensee_f_8(X), hasTheme_f_8(Ev,P), product_f_8(P), isLicenceOf_f_8(L,P), licence_f_8(L), grant_f_8(Eg), rexist_f_8(Eg), hasTheme_f_8(Eg,L), hasAgent_f_8(Eg,Y), licensor_f_8(Y), hasReceiver_f_8(Eg,X).

exception(prohibited_8(Ev), permitted_8(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_8 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_8. If the licencee publish the results of the evaluation 
% even if this was prohibited_8, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_8 for the licencee to publish the results of the evaluation of the product
prohibited_8(Ep) <= condition_2_8(Ep,X,R).
condition_2_8(Ep,X,R) <= publish_f_8(Ep), hasAgent_f_8(Ep,X), licensee_f_8(X), hasTheme_f_8(Ep,R), result_f_8(R), hasResult_f_8(Ev,R), evaluate_f_8(Ev), rexist_f_8(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_8. Art.2b is an exception of Art2.a.
permitted_8(Ep) <= publish_f_8(Ep), hasAgent_f_8(Ep,X), licensee_f_8(X), hasTheme_f_8(Ep,R), result_f_8(R), hasResult_f_8(Ev,R), evaluate_f_8(Ev), rexist_f_8(Ev), approve_f_8(Ea), rexist_f_8(Ea), hasTheme_f_8(Ea,Ep), licensor_f_8(Y), hasAgent_f_8(Ea,Y).

exception(condition_2_8(Ep,X,R),permitted_8(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_8 to do so, he is obliged to remove them. The removal compensate_8s the violation_8 of the prohibition.
obligatory_8(ca(Ep,X,R)) <= rexist_f_8(Ep), condition_2_8(Ep,X,R).
remove_8(ca(Ep,X,R)) <= rexist_f_8(Ep), condition_2_8(Ep,X,R).
hasTheme_8(ca(Ep,X,R),R) <= rexist_f_8(Ep), condition_2_8(Ep,X,R).
hasAgent_8(ca(Ep,X,R),X) <= rexist_f_8(Ep), condition_2_8(Ep,X,R).
compensate_8(ca(Ep,X,R),Ep) <= rexist_f_8(Ep), condition_2_8(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_8 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_8.
prohibited_8(Ep) <= publish_f_8(Ep), hasAgent_f_8(Ep,X), licensee_f_8(X), hasTheme_f_8(Ep,C), comment_f_8(C), evaluate_f_8(Ev), rexist_f_8(Ev), isCommentOf_f_8(C,Ev).

% Art.3b: if publishing the result is permitted_8, also publishing the comments is permitted_8; this overrides the above prohibition.
permitted_8(Ep) <= publish_f_8(Ep), hasAgent_f_8(Ep,X), licensee_f_8(X), hasTheme_f_8(Ep,C), comment_f_8(C), isCommentOf_f_8(C,Ev), evaluate_f_8(Ev), rexist_f_8(Ev), hasResult_f_8(Ev,R), publish_f_8(Epr), hasAgent_f_8(Epr,X), hasTheme_f_8(Epr,R), permitted_8(Epr).

exception(prohibited_8(Ep),permitted_8(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_8. Art.4a is an exception of Art2.a.

obligatory_8(Ep) <= publish_f_8(Ep), hasAgent_f_8(Ep,X), licensee_f_8(X), hasTheme_f_8(Ep,R), result_f_8(R), hasResult_f_8(Ev,R), evaluate_f_8(Ev), rexist_f_8(Ev), commission_f_8(Ec), rexist_f_8(Ec), hasTheme_f_8(Ec,Ev).
exception(condition_2_8(Ep,X,R),obligatory_8(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_8 action x and, at the same time, x does not really exist => violation_8; 
%(2) if there is some prohibited_8 action x and, at the same time, x really exists => violation_8

rexist_8(ca(Ep,X,R)) <= remove_8(ca(Ep,X,R)), hasAgent_8(ca(Ep,X,R),X), hasTheme_8(ca(Ep,X,R),R), rexist_f_8(Er), remove_f_8(Er), hasTheme_f_8(Er,R), hasAgent_f_8(Er,X).

violation_8(viol(X)) <= obligatory_8(X).
-violation_8(viol(X)) <= obligatory_8(X), rexist_8(X).
exception(violation_8(X),-violation_8(X)).

violation_8(viol(X)) <= prohibited_8(X), rexist_8(X).

referTo_8(viol(X),X) <= violation_8(viol(X)).

compensate_8d_8(X) <= compensate_8(Y,X), rexist_8(Y).
exception(violation_8(viol(X)),compensate_8d_8(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_8(X) <= rexist_f_8(X).
licensee_8(X) <= licensee_f_8(X).
licensor_8(X) <= licensor_f_8(X).
product_8(X) <= product_f_8(X).
result_8(X) <= result_f_8(X).
licence_8(X) <= licence_f_8(X).
comment_8(X) <= comment_f_8(X).
isLicenceOf_8(X,Y) <= isLicenceOf_f_8(X,Y).
                
approve_8(X) <= approve_f_8(X).
commission_8(X) <= commission_f_8(X).
evaluate_8(X) <= evaluate_f_8(X).
grant_8(X) <= grant_f_8(X).
publish_8(X) <= publish_f_8(X).
remove_8(X) <= remove_f_8(X).
                
hasAgent_8(X,Y) <= hasAgent_f_8(X,Y).
hasTheme_8(X,Y) <= hasTheme_f_8(X,Y).
hasResult_8(X,Y) <= hasResult_f_8(X,Y).
hasReceiver_8(X,Y) <= hasReceiver_f_8(X,Y).
isCommentOf_8(X,Y) <= isCommentOf_f_8(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_9 to evaluate the product only with a licence; otherwise, it is prohibited_9.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_9 for the licencee to evaluate the product

prohibited_9(Ev) <= evaluate_f_9(Ev), hasAgent_f_9(Ev,X), licensee_f_9(X), hasTheme_f_9(Ev,P), product_f_9(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_9. Art.1b is an exception of Art1.a.
permitted_9(Ev) <= evaluate_f_9(Ev), hasAgent_f_9(Ev,X), licensee_f_9(X), hasTheme_f_9(Ev,P), product_f_9(P), isLicenceOf_f_9(L,P), licence_f_9(L), grant_f_9(Eg), rexist_f_9(Eg), hasTheme_f_9(Eg,L), hasAgent_f_9(Eg,Y), licensor_f_9(Y), hasReceiver_f_9(Eg,X).

exception(prohibited_9(Ev), permitted_9(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_9 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_9. If the licencee publish the results of the evaluation 
% even if this was prohibited_9, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_9 for the licencee to publish the results of the evaluation of the product
prohibited_9(Ep) <= condition_2_9(Ep,X,R).
condition_2_9(Ep,X,R) <= publish_f_9(Ep), hasAgent_f_9(Ep,X), licensee_f_9(X), hasTheme_f_9(Ep,R), result_f_9(R), hasResult_f_9(Ev,R), evaluate_f_9(Ev), rexist_f_9(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_9. Art.2b is an exception of Art2.a.
permitted_9(Ep) <= publish_f_9(Ep), hasAgent_f_9(Ep,X), licensee_f_9(X), hasTheme_f_9(Ep,R), result_f_9(R), hasResult_f_9(Ev,R), evaluate_f_9(Ev), rexist_f_9(Ev), approve_f_9(Ea), rexist_f_9(Ea), hasTheme_f_9(Ea,Ep), licensor_f_9(Y), hasAgent_f_9(Ea,Y).

exception(condition_2_9(Ep,X,R),permitted_9(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_9 to do so, he is obliged to remove them. The removal compensate_9s the violation_9 of the prohibition.
obligatory_9(ca(Ep,X,R)) <= rexist_f_9(Ep), condition_2_9(Ep,X,R).
remove_9(ca(Ep,X,R)) <= rexist_f_9(Ep), condition_2_9(Ep,X,R).
hasTheme_9(ca(Ep,X,R),R) <= rexist_f_9(Ep), condition_2_9(Ep,X,R).
hasAgent_9(ca(Ep,X,R),X) <= rexist_f_9(Ep), condition_2_9(Ep,X,R).
compensate_9(ca(Ep,X,R),Ep) <= rexist_f_9(Ep), condition_2_9(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_9 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_9.
prohibited_9(Ep) <= publish_f_9(Ep), hasAgent_f_9(Ep,X), licensee_f_9(X), hasTheme_f_9(Ep,C), comment_f_9(C), evaluate_f_9(Ev), rexist_f_9(Ev), isCommentOf_f_9(C,Ev).

% Art.3b: if publishing the result is permitted_9, also publishing the comments is permitted_9; this overrides the above prohibition.
permitted_9(Ep) <= publish_f_9(Ep), hasAgent_f_9(Ep,X), licensee_f_9(X), hasTheme_f_9(Ep,C), comment_f_9(C), isCommentOf_f_9(C,Ev), evaluate_f_9(Ev), rexist_f_9(Ev), hasResult_f_9(Ev,R), publish_f_9(Epr), hasAgent_f_9(Epr,X), hasTheme_f_9(Epr,R), permitted_9(Epr).

exception(prohibited_9(Ep),permitted_9(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_9. Art.4a is an exception of Art2.a.

obligatory_9(Ep) <= publish_f_9(Ep), hasAgent_f_9(Ep,X), licensee_f_9(X), hasTheme_f_9(Ep,R), result_f_9(R), hasResult_f_9(Ev,R), evaluate_f_9(Ev), rexist_f_9(Ev), commission_f_9(Ec), rexist_f_9(Ec), hasTheme_f_9(Ec,Ev).
exception(condition_2_9(Ep,X,R),obligatory_9(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_9 action x and, at the same time, x does not really exist => violation_9; 
%(2) if there is some prohibited_9 action x and, at the same time, x really exists => violation_9

rexist_9(ca(Ep,X,R)) <= remove_9(ca(Ep,X,R)), hasAgent_9(ca(Ep,X,R),X), hasTheme_9(ca(Ep,X,R),R), rexist_f_9(Er), remove_f_9(Er), hasTheme_f_9(Er,R), hasAgent_f_9(Er,X).

violation_9(viol(X)) <= obligatory_9(X).
-violation_9(viol(X)) <= obligatory_9(X), rexist_9(X).
exception(violation_9(X),-violation_9(X)).

violation_9(viol(X)) <= prohibited_9(X), rexist_9(X).

referTo_9(viol(X),X) <= violation_9(viol(X)).

compensate_9d_9(X) <= compensate_9(Y,X), rexist_9(Y).
exception(violation_9(viol(X)),compensate_9d_9(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_9(X) <= rexist_f_9(X).
licensee_9(X) <= licensee_f_9(X).
licensor_9(X) <= licensor_f_9(X).
product_9(X) <= product_f_9(X).
result_9(X) <= result_f_9(X).
licence_9(X) <= licence_f_9(X).
comment_9(X) <= comment_f_9(X).
isLicenceOf_9(X,Y) <= isLicenceOf_f_9(X,Y).
                
approve_9(X) <= approve_f_9(X).
commission_9(X) <= commission_f_9(X).
evaluate_9(X) <= evaluate_f_9(X).
grant_9(X) <= grant_f_9(X).
publish_9(X) <= publish_f_9(X).
remove_9(X) <= remove_f_9(X).
                
hasAgent_9(X,Y) <= hasAgent_f_9(X,Y).
hasTheme_9(X,Y) <= hasTheme_f_9(X,Y).
hasResult_9(X,Y) <= hasResult_f_9(X,Y).
hasReceiver_9(X,Y) <= hasReceiver_f_9(X,Y).
isCommentOf_9(X,Y) <= isCommentOf_f_9(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_10 to evaluate the product only with a licence; otherwise, it is prohibited_10.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_10 for the licencee to evaluate the product

prohibited_10(Ev) <= evaluate_f_10(Ev), hasAgent_f_10(Ev,X), licensee_f_10(X), hasTheme_f_10(Ev,P), product_f_10(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_10. Art.1b is an exception of Art1.a.
permitted_10(Ev) <= evaluate_f_10(Ev), hasAgent_f_10(Ev,X), licensee_f_10(X), hasTheme_f_10(Ev,P), product_f_10(P), isLicenceOf_f_10(L,P), licence_f_10(L), grant_f_10(Eg), rexist_f_10(Eg), hasTheme_f_10(Eg,L), hasAgent_f_10(Eg,Y), licensor_f_10(Y), hasReceiver_f_10(Eg,X).

exception(prohibited_10(Ev), permitted_10(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_10 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_10. If the licencee publish the results of the evaluation 
% even if this was prohibited_10, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_10 for the licencee to publish the results of the evaluation of the product
prohibited_10(Ep) <= condition_2_10(Ep,X,R).
condition_2_10(Ep,X,R) <= publish_f_10(Ep), hasAgent_f_10(Ep,X), licensee_f_10(X), hasTheme_f_10(Ep,R), result_f_10(R), hasResult_f_10(Ev,R), evaluate_f_10(Ev), rexist_f_10(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_10. Art.2b is an exception of Art2.a.
permitted_10(Ep) <= publish_f_10(Ep), hasAgent_f_10(Ep,X), licensee_f_10(X), hasTheme_f_10(Ep,R), result_f_10(R), hasResult_f_10(Ev,R), evaluate_f_10(Ev), rexist_f_10(Ev), approve_f_10(Ea), rexist_f_10(Ea), hasTheme_f_10(Ea,Ep), licensor_f_10(Y), hasAgent_f_10(Ea,Y).

exception(condition_2_10(Ep,X,R),permitted_10(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_10 to do so, he is obliged to remove them. The removal compensate_10s the violation_10 of the prohibition.
obligatory_10(ca(Ep,X,R)) <= rexist_f_10(Ep), condition_2_10(Ep,X,R).
remove_10(ca(Ep,X,R)) <= rexist_f_10(Ep), condition_2_10(Ep,X,R).
hasTheme_10(ca(Ep,X,R),R) <= rexist_f_10(Ep), condition_2_10(Ep,X,R).
hasAgent_10(ca(Ep,X,R),X) <= rexist_f_10(Ep), condition_2_10(Ep,X,R).
compensate_10(ca(Ep,X,R),Ep) <= rexist_f_10(Ep), condition_2_10(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_10 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_10.
prohibited_10(Ep) <= publish_f_10(Ep), hasAgent_f_10(Ep,X), licensee_f_10(X), hasTheme_f_10(Ep,C), comment_f_10(C), evaluate_f_10(Ev), rexist_f_10(Ev), isCommentOf_f_10(C,Ev).

% Art.3b: if publishing the result is permitted_10, also publishing the comments is permitted_10; this overrides the above prohibition.
permitted_10(Ep) <= publish_f_10(Ep), hasAgent_f_10(Ep,X), licensee_f_10(X), hasTheme_f_10(Ep,C), comment_f_10(C), isCommentOf_f_10(C,Ev), evaluate_f_10(Ev), rexist_f_10(Ev), hasResult_f_10(Ev,R), publish_f_10(Epr), hasAgent_f_10(Epr,X), hasTheme_f_10(Epr,R), permitted_10(Epr).

exception(prohibited_10(Ep),permitted_10(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_10. Art.4a is an exception of Art2.a.

obligatory_10(Ep) <= publish_f_10(Ep), hasAgent_f_10(Ep,X), licensee_f_10(X), hasTheme_f_10(Ep,R), result_f_10(R), hasResult_f_10(Ev,R), evaluate_f_10(Ev), rexist_f_10(Ev), commission_f_10(Ec), rexist_f_10(Ec), hasTheme_f_10(Ec,Ev).
exception(condition_2_10(Ep,X,R),obligatory_10(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_10 action x and, at the same time, x does not really exist => violation_10; 
%(2) if there is some prohibited_10 action x and, at the same time, x really exists => violation_10

rexist_10(ca(Ep,X,R)) <= remove_10(ca(Ep,X,R)), hasAgent_10(ca(Ep,X,R),X), hasTheme_10(ca(Ep,X,R),R), rexist_f_10(Er), remove_f_10(Er), hasTheme_f_10(Er,R), hasAgent_f_10(Er,X).

violation_10(viol(X)) <= obligatory_10(X).
-violation_10(viol(X)) <= obligatory_10(X), rexist_10(X).
exception(violation_10(X),-violation_10(X)).

violation_10(viol(X)) <= prohibited_10(X), rexist_10(X).

referTo_10(viol(X),X) <= violation_10(viol(X)).

compensate_10d_10(X) <= compensate_10(Y,X), rexist_10(Y).
exception(violation_10(viol(X)),compensate_10d_10(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_10(X) <= rexist_f_10(X).
licensee_10(X) <= licensee_f_10(X).
licensor_10(X) <= licensor_f_10(X).
product_10(X) <= product_f_10(X).
result_10(X) <= result_f_10(X).
licence_10(X) <= licence_f_10(X).
comment_10(X) <= comment_f_10(X).
isLicenceOf_10(X,Y) <= isLicenceOf_f_10(X,Y).
                
approve_10(X) <= approve_f_10(X).
commission_10(X) <= commission_f_10(X).
evaluate_10(X) <= evaluate_f_10(X).
grant_10(X) <= grant_f_10(X).
publish_10(X) <= publish_f_10(X).
remove_10(X) <= remove_f_10(X).
                
hasAgent_10(X,Y) <= hasAgent_f_10(X,Y).
hasTheme_10(X,Y) <= hasTheme_f_10(X,Y).
hasResult_10(X,Y) <= hasResult_f_10(X,Y).
hasReceiver_10(X,Y) <= hasReceiver_f_10(X,Y).
isCommentOf_10(X,Y) <= isCommentOf_f_10(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_11 to evaluate the product only with a licence; otherwise, it is prohibited_11.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_11 for the licencee to evaluate the product

prohibited_11(Ev) <= evaluate_f_11(Ev), hasAgent_f_11(Ev,X), licensee_f_11(X), hasTheme_f_11(Ev,P), product_f_11(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_11. Art.1b is an exception of Art1.a.
permitted_11(Ev) <= evaluate_f_11(Ev), hasAgent_f_11(Ev,X), licensee_f_11(X), hasTheme_f_11(Ev,P), product_f_11(P), isLicenceOf_f_11(L,P), licence_f_11(L), grant_f_11(Eg), rexist_f_11(Eg), hasTheme_f_11(Eg,L), hasAgent_f_11(Eg,Y), licensor_f_11(Y), hasReceiver_f_11(Eg,X).

exception(prohibited_11(Ev), permitted_11(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_11 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_11. If the licencee publish the results of the evaluation 
% even if this was prohibited_11, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_11 for the licencee to publish the results of the evaluation of the product
prohibited_11(Ep) <= condition_2_11(Ep,X,R).
condition_2_11(Ep,X,R) <= publish_f_11(Ep), hasAgent_f_11(Ep,X), licensee_f_11(X), hasTheme_f_11(Ep,R), result_f_11(R), hasResult_f_11(Ev,R), evaluate_f_11(Ev), rexist_f_11(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_11. Art.2b is an exception of Art2.a.
permitted_11(Ep) <= publish_f_11(Ep), hasAgent_f_11(Ep,X), licensee_f_11(X), hasTheme_f_11(Ep,R), result_f_11(R), hasResult_f_11(Ev,R), evaluate_f_11(Ev), rexist_f_11(Ev), approve_f_11(Ea), rexist_f_11(Ea), hasTheme_f_11(Ea,Ep), licensor_f_11(Y), hasAgent_f_11(Ea,Y).

exception(condition_2_11(Ep,X,R),permitted_11(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_11 to do so, he is obliged to remove them. The removal compensate_11s the violation_11 of the prohibition.
obligatory_11(ca(Ep,X,R)) <= rexist_f_11(Ep), condition_2_11(Ep,X,R).
remove_11(ca(Ep,X,R)) <= rexist_f_11(Ep), condition_2_11(Ep,X,R).
hasTheme_11(ca(Ep,X,R),R) <= rexist_f_11(Ep), condition_2_11(Ep,X,R).
hasAgent_11(ca(Ep,X,R),X) <= rexist_f_11(Ep), condition_2_11(Ep,X,R).
compensate_11(ca(Ep,X,R),Ep) <= rexist_f_11(Ep), condition_2_11(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_11 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_11.
prohibited_11(Ep) <= publish_f_11(Ep), hasAgent_f_11(Ep,X), licensee_f_11(X), hasTheme_f_11(Ep,C), comment_f_11(C), evaluate_f_11(Ev), rexist_f_11(Ev), isCommentOf_f_11(C,Ev).

% Art.3b: if publishing the result is permitted_11, also publishing the comments is permitted_11; this overrides the above prohibition.
permitted_11(Ep) <= publish_f_11(Ep), hasAgent_f_11(Ep,X), licensee_f_11(X), hasTheme_f_11(Ep,C), comment_f_11(C), isCommentOf_f_11(C,Ev), evaluate_f_11(Ev), rexist_f_11(Ev), hasResult_f_11(Ev,R), publish_f_11(Epr), hasAgent_f_11(Epr,X), hasTheme_f_11(Epr,R), permitted_11(Epr).

exception(prohibited_11(Ep),permitted_11(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_11. Art.4a is an exception of Art2.a.

obligatory_11(Ep) <= publish_f_11(Ep), hasAgent_f_11(Ep,X), licensee_f_11(X), hasTheme_f_11(Ep,R), result_f_11(R), hasResult_f_11(Ev,R), evaluate_f_11(Ev), rexist_f_11(Ev), commission_f_11(Ec), rexist_f_11(Ec), hasTheme_f_11(Ec,Ev).
exception(condition_2_11(Ep,X,R),obligatory_11(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_11 action x and, at the same time, x does not really exist => violation_11; 
%(2) if there is some prohibited_11 action x and, at the same time, x really exists => violation_11

rexist_11(ca(Ep,X,R)) <= remove_11(ca(Ep,X,R)), hasAgent_11(ca(Ep,X,R),X), hasTheme_11(ca(Ep,X,R),R), rexist_f_11(Er), remove_f_11(Er), hasTheme_f_11(Er,R), hasAgent_f_11(Er,X).

violation_11(viol(X)) <= obligatory_11(X).
-violation_11(viol(X)) <= obligatory_11(X), rexist_11(X).
exception(violation_11(X),-violation_11(X)).

violation_11(viol(X)) <= prohibited_11(X), rexist_11(X).

referTo_11(viol(X),X) <= violation_11(viol(X)).

compensate_11d_11(X) <= compensate_11(Y,X), rexist_11(Y).
exception(violation_11(viol(X)),compensate_11d_11(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_11(X) <= rexist_f_11(X).
licensee_11(X) <= licensee_f_11(X).
licensor_11(X) <= licensor_f_11(X).
product_11(X) <= product_f_11(X).
result_11(X) <= result_f_11(X).
licence_11(X) <= licence_f_11(X).
comment_11(X) <= comment_f_11(X).
isLicenceOf_11(X,Y) <= isLicenceOf_f_11(X,Y).
                
approve_11(X) <= approve_f_11(X).
commission_11(X) <= commission_f_11(X).
evaluate_11(X) <= evaluate_f_11(X).
grant_11(X) <= grant_f_11(X).
publish_11(X) <= publish_f_11(X).
remove_11(X) <= remove_f_11(X).
                
hasAgent_11(X,Y) <= hasAgent_f_11(X,Y).
hasTheme_11(X,Y) <= hasTheme_f_11(X,Y).
hasResult_11(X,Y) <= hasResult_f_11(X,Y).
hasReceiver_11(X,Y) <= hasReceiver_f_11(X,Y).
isCommentOf_11(X,Y) <= isCommentOf_f_11(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_12 to evaluate the product only with a licence; otherwise, it is prohibited_12.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_12 for the licencee to evaluate the product

prohibited_12(Ev) <= evaluate_f_12(Ev), hasAgent_f_12(Ev,X), licensee_f_12(X), hasTheme_f_12(Ev,P), product_f_12(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_12. Art.1b is an exception of Art1.a.
permitted_12(Ev) <= evaluate_f_12(Ev), hasAgent_f_12(Ev,X), licensee_f_12(X), hasTheme_f_12(Ev,P), product_f_12(P), isLicenceOf_f_12(L,P), licence_f_12(L), grant_f_12(Eg), rexist_f_12(Eg), hasTheme_f_12(Eg,L), hasAgent_f_12(Eg,Y), licensor_f_12(Y), hasReceiver_f_12(Eg,X).

exception(prohibited_12(Ev), permitted_12(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_12 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_12. If the licencee publish the results of the evaluation 
% even if this was prohibited_12, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_12 for the licencee to publish the results of the evaluation of the product
prohibited_12(Ep) <= condition_2_12(Ep,X,R).
condition_2_12(Ep,X,R) <= publish_f_12(Ep), hasAgent_f_12(Ep,X), licensee_f_12(X), hasTheme_f_12(Ep,R), result_f_12(R), hasResult_f_12(Ev,R), evaluate_f_12(Ev), rexist_f_12(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_12. Art.2b is an exception of Art2.a.
permitted_12(Ep) <= publish_f_12(Ep), hasAgent_f_12(Ep,X), licensee_f_12(X), hasTheme_f_12(Ep,R), result_f_12(R), hasResult_f_12(Ev,R), evaluate_f_12(Ev), rexist_f_12(Ev), approve_f_12(Ea), rexist_f_12(Ea), hasTheme_f_12(Ea,Ep), licensor_f_12(Y), hasAgent_f_12(Ea,Y).

exception(condition_2_12(Ep,X,R),permitted_12(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_12 to do so, he is obliged to remove them. The removal compensate_12s the violation_12 of the prohibition.
obligatory_12(ca(Ep,X,R)) <= rexist_f_12(Ep), condition_2_12(Ep,X,R).
remove_12(ca(Ep,X,R)) <= rexist_f_12(Ep), condition_2_12(Ep,X,R).
hasTheme_12(ca(Ep,X,R),R) <= rexist_f_12(Ep), condition_2_12(Ep,X,R).
hasAgent_12(ca(Ep,X,R),X) <= rexist_f_12(Ep), condition_2_12(Ep,X,R).
compensate_12(ca(Ep,X,R),Ep) <= rexist_f_12(Ep), condition_2_12(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_12 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_12.
prohibited_12(Ep) <= publish_f_12(Ep), hasAgent_f_12(Ep,X), licensee_f_12(X), hasTheme_f_12(Ep,C), comment_f_12(C), evaluate_f_12(Ev), rexist_f_12(Ev), isCommentOf_f_12(C,Ev).

% Art.3b: if publishing the result is permitted_12, also publishing the comments is permitted_12; this overrides the above prohibition.
permitted_12(Ep) <= publish_f_12(Ep), hasAgent_f_12(Ep,X), licensee_f_12(X), hasTheme_f_12(Ep,C), comment_f_12(C), isCommentOf_f_12(C,Ev), evaluate_f_12(Ev), rexist_f_12(Ev), hasResult_f_12(Ev,R), publish_f_12(Epr), hasAgent_f_12(Epr,X), hasTheme_f_12(Epr,R), permitted_12(Epr).

exception(prohibited_12(Ep),permitted_12(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_12. Art.4a is an exception of Art2.a.

obligatory_12(Ep) <= publish_f_12(Ep), hasAgent_f_12(Ep,X), licensee_f_12(X), hasTheme_f_12(Ep,R), result_f_12(R), hasResult_f_12(Ev,R), evaluate_f_12(Ev), rexist_f_12(Ev), commission_f_12(Ec), rexist_f_12(Ec), hasTheme_f_12(Ec,Ev).
exception(condition_2_12(Ep,X,R),obligatory_12(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_12 action x and, at the same time, x does not really exist => violation_12; 
%(2) if there is some prohibited_12 action x and, at the same time, x really exists => violation_12

rexist_12(ca(Ep,X,R)) <= remove_12(ca(Ep,X,R)), hasAgent_12(ca(Ep,X,R),X), hasTheme_12(ca(Ep,X,R),R), rexist_f_12(Er), remove_f_12(Er), hasTheme_f_12(Er,R), hasAgent_f_12(Er,X).

violation_12(viol(X)) <= obligatory_12(X).
-violation_12(viol(X)) <= obligatory_12(X), rexist_12(X).
exception(violation_12(X),-violation_12(X)).

violation_12(viol(X)) <= prohibited_12(X), rexist_12(X).

referTo_12(viol(X),X) <= violation_12(viol(X)).

compensate_12d_12(X) <= compensate_12(Y,X), rexist_12(Y).
exception(violation_12(viol(X)),compensate_12d_12(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_12(X) <= rexist_f_12(X).
licensee_12(X) <= licensee_f_12(X).
licensor_12(X) <= licensor_f_12(X).
product_12(X) <= product_f_12(X).
result_12(X) <= result_f_12(X).
licence_12(X) <= licence_f_12(X).
comment_12(X) <= comment_f_12(X).
isLicenceOf_12(X,Y) <= isLicenceOf_f_12(X,Y).
                
approve_12(X) <= approve_f_12(X).
commission_12(X) <= commission_f_12(X).
evaluate_12(X) <= evaluate_f_12(X).
grant_12(X) <= grant_f_12(X).
publish_12(X) <= publish_f_12(X).
remove_12(X) <= remove_f_12(X).
                
hasAgent_12(X,Y) <= hasAgent_f_12(X,Y).
hasTheme_12(X,Y) <= hasTheme_f_12(X,Y).
hasResult_12(X,Y) <= hasResult_f_12(X,Y).
hasReceiver_12(X,Y) <= hasReceiver_f_12(X,Y).
isCommentOf_12(X,Y) <= isCommentOf_f_12(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_13 to evaluate the product only with a licence; otherwise, it is prohibited_13.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_13 for the licencee to evaluate the product

prohibited_13(Ev) <= evaluate_f_13(Ev), hasAgent_f_13(Ev,X), licensee_f_13(X), hasTheme_f_13(Ev,P), product_f_13(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_13. Art.1b is an exception of Art1.a.
permitted_13(Ev) <= evaluate_f_13(Ev), hasAgent_f_13(Ev,X), licensee_f_13(X), hasTheme_f_13(Ev,P), product_f_13(P), isLicenceOf_f_13(L,P), licence_f_13(L), grant_f_13(Eg), rexist_f_13(Eg), hasTheme_f_13(Eg,L), hasAgent_f_13(Eg,Y), licensor_f_13(Y), hasReceiver_f_13(Eg,X).

exception(prohibited_13(Ev), permitted_13(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_13 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_13. If the licencee publish the results of the evaluation 
% even if this was prohibited_13, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_13 for the licencee to publish the results of the evaluation of the product
prohibited_13(Ep) <= condition_2_13(Ep,X,R).
condition_2_13(Ep,X,R) <= publish_f_13(Ep), hasAgent_f_13(Ep,X), licensee_f_13(X), hasTheme_f_13(Ep,R), result_f_13(R), hasResult_f_13(Ev,R), evaluate_f_13(Ev), rexist_f_13(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_13. Art.2b is an exception of Art2.a.
permitted_13(Ep) <= publish_f_13(Ep), hasAgent_f_13(Ep,X), licensee_f_13(X), hasTheme_f_13(Ep,R), result_f_13(R), hasResult_f_13(Ev,R), evaluate_f_13(Ev), rexist_f_13(Ev), approve_f_13(Ea), rexist_f_13(Ea), hasTheme_f_13(Ea,Ep), licensor_f_13(Y), hasAgent_f_13(Ea,Y).

exception(condition_2_13(Ep,X,R),permitted_13(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_13 to do so, he is obliged to remove them. The removal compensate_13s the violation_13 of the prohibition.
obligatory_13(ca(Ep,X,R)) <= rexist_f_13(Ep), condition_2_13(Ep,X,R).
remove_13(ca(Ep,X,R)) <= rexist_f_13(Ep), condition_2_13(Ep,X,R).
hasTheme_13(ca(Ep,X,R),R) <= rexist_f_13(Ep), condition_2_13(Ep,X,R).
hasAgent_13(ca(Ep,X,R),X) <= rexist_f_13(Ep), condition_2_13(Ep,X,R).
compensate_13(ca(Ep,X,R),Ep) <= rexist_f_13(Ep), condition_2_13(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_13 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_13.
prohibited_13(Ep) <= publish_f_13(Ep), hasAgent_f_13(Ep,X), licensee_f_13(X), hasTheme_f_13(Ep,C), comment_f_13(C), evaluate_f_13(Ev), rexist_f_13(Ev), isCommentOf_f_13(C,Ev).

% Art.3b: if publishing the result is permitted_13, also publishing the comments is permitted_13; this overrides the above prohibition.
permitted_13(Ep) <= publish_f_13(Ep), hasAgent_f_13(Ep,X), licensee_f_13(X), hasTheme_f_13(Ep,C), comment_f_13(C), isCommentOf_f_13(C,Ev), evaluate_f_13(Ev), rexist_f_13(Ev), hasResult_f_13(Ev,R), publish_f_13(Epr), hasAgent_f_13(Epr,X), hasTheme_f_13(Epr,R), permitted_13(Epr).

exception(prohibited_13(Ep),permitted_13(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_13. Art.4a is an exception of Art2.a.

obligatory_13(Ep) <= publish_f_13(Ep), hasAgent_f_13(Ep,X), licensee_f_13(X), hasTheme_f_13(Ep,R), result_f_13(R), hasResult_f_13(Ev,R), evaluate_f_13(Ev), rexist_f_13(Ev), commission_f_13(Ec), rexist_f_13(Ec), hasTheme_f_13(Ec,Ev).
exception(condition_2_13(Ep,X,R),obligatory_13(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_13 action x and, at the same time, x does not really exist => violation_13; 
%(2) if there is some prohibited_13 action x and, at the same time, x really exists => violation_13

rexist_13(ca(Ep,X,R)) <= remove_13(ca(Ep,X,R)), hasAgent_13(ca(Ep,X,R),X), hasTheme_13(ca(Ep,X,R),R), rexist_f_13(Er), remove_f_13(Er), hasTheme_f_13(Er,R), hasAgent_f_13(Er,X).

violation_13(viol(X)) <= obligatory_13(X).
-violation_13(viol(X)) <= obligatory_13(X), rexist_13(X).
exception(violation_13(X),-violation_13(X)).

violation_13(viol(X)) <= prohibited_13(X), rexist_13(X).

referTo_13(viol(X),X) <= violation_13(viol(X)).

compensate_13d_13(X) <= compensate_13(Y,X), rexist_13(Y).
exception(violation_13(viol(X)),compensate_13d_13(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_13(X) <= rexist_f_13(X).
licensee_13(X) <= licensee_f_13(X).
licensor_13(X) <= licensor_f_13(X).
product_13(X) <= product_f_13(X).
result_13(X) <= result_f_13(X).
licence_13(X) <= licence_f_13(X).
comment_13(X) <= comment_f_13(X).
isLicenceOf_13(X,Y) <= isLicenceOf_f_13(X,Y).
                
approve_13(X) <= approve_f_13(X).
commission_13(X) <= commission_f_13(X).
evaluate_13(X) <= evaluate_f_13(X).
grant_13(X) <= grant_f_13(X).
publish_13(X) <= publish_f_13(X).
remove_13(X) <= remove_f_13(X).
                
hasAgent_13(X,Y) <= hasAgent_f_13(X,Y).
hasTheme_13(X,Y) <= hasTheme_f_13(X,Y).
hasResult_13(X,Y) <= hasResult_f_13(X,Y).
hasReceiver_13(X,Y) <= hasReceiver_f_13(X,Y).
isCommentOf_13(X,Y) <= isCommentOf_f_13(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_14 to evaluate the product only with a licence; otherwise, it is prohibited_14.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_14 for the licencee to evaluate the product

prohibited_14(Ev) <= evaluate_f_14(Ev), hasAgent_f_14(Ev,X), licensee_f_14(X), hasTheme_f_14(Ev,P), product_f_14(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_14. Art.1b is an exception of Art1.a.
permitted_14(Ev) <= evaluate_f_14(Ev), hasAgent_f_14(Ev,X), licensee_f_14(X), hasTheme_f_14(Ev,P), product_f_14(P), isLicenceOf_f_14(L,P), licence_f_14(L), grant_f_14(Eg), rexist_f_14(Eg), hasTheme_f_14(Eg,L), hasAgent_f_14(Eg,Y), licensor_f_14(Y), hasReceiver_f_14(Eg,X).

exception(prohibited_14(Ev), permitted_14(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_14 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_14. If the licencee publish the results of the evaluation 
% even if this was prohibited_14, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_14 for the licencee to publish the results of the evaluation of the product
prohibited_14(Ep) <= condition_2_14(Ep,X,R).
condition_2_14(Ep,X,R) <= publish_f_14(Ep), hasAgent_f_14(Ep,X), licensee_f_14(X), hasTheme_f_14(Ep,R), result_f_14(R), hasResult_f_14(Ev,R), evaluate_f_14(Ev), rexist_f_14(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_14. Art.2b is an exception of Art2.a.
permitted_14(Ep) <= publish_f_14(Ep), hasAgent_f_14(Ep,X), licensee_f_14(X), hasTheme_f_14(Ep,R), result_f_14(R), hasResult_f_14(Ev,R), evaluate_f_14(Ev), rexist_f_14(Ev), approve_f_14(Ea), rexist_f_14(Ea), hasTheme_f_14(Ea,Ep), licensor_f_14(Y), hasAgent_f_14(Ea,Y).

exception(condition_2_14(Ep,X,R),permitted_14(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_14 to do so, he is obliged to remove them. The removal compensate_14s the violation_14 of the prohibition.
obligatory_14(ca(Ep,X,R)) <= rexist_f_14(Ep), condition_2_14(Ep,X,R).
remove_14(ca(Ep,X,R)) <= rexist_f_14(Ep), condition_2_14(Ep,X,R).
hasTheme_14(ca(Ep,X,R),R) <= rexist_f_14(Ep), condition_2_14(Ep,X,R).
hasAgent_14(ca(Ep,X,R),X) <= rexist_f_14(Ep), condition_2_14(Ep,X,R).
compensate_14(ca(Ep,X,R),Ep) <= rexist_f_14(Ep), condition_2_14(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_14 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_14.
prohibited_14(Ep) <= publish_f_14(Ep), hasAgent_f_14(Ep,X), licensee_f_14(X), hasTheme_f_14(Ep,C), comment_f_14(C), evaluate_f_14(Ev), rexist_f_14(Ev), isCommentOf_f_14(C,Ev).

% Art.3b: if publishing the result is permitted_14, also publishing the comments is permitted_14; this overrides the above prohibition.
permitted_14(Ep) <= publish_f_14(Ep), hasAgent_f_14(Ep,X), licensee_f_14(X), hasTheme_f_14(Ep,C), comment_f_14(C), isCommentOf_f_14(C,Ev), evaluate_f_14(Ev), rexist_f_14(Ev), hasResult_f_14(Ev,R), publish_f_14(Epr), hasAgent_f_14(Epr,X), hasTheme_f_14(Epr,R), permitted_14(Epr).

exception(prohibited_14(Ep),permitted_14(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_14. Art.4a is an exception of Art2.a.

obligatory_14(Ep) <= publish_f_14(Ep), hasAgent_f_14(Ep,X), licensee_f_14(X), hasTheme_f_14(Ep,R), result_f_14(R), hasResult_f_14(Ev,R), evaluate_f_14(Ev), rexist_f_14(Ev), commission_f_14(Ec), rexist_f_14(Ec), hasTheme_f_14(Ec,Ev).
exception(condition_2_14(Ep,X,R),obligatory_14(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_14 action x and, at the same time, x does not really exist => violation_14; 
%(2) if there is some prohibited_14 action x and, at the same time, x really exists => violation_14

rexist_14(ca(Ep,X,R)) <= remove_14(ca(Ep,X,R)), hasAgent_14(ca(Ep,X,R),X), hasTheme_14(ca(Ep,X,R),R), rexist_f_14(Er), remove_f_14(Er), hasTheme_f_14(Er,R), hasAgent_f_14(Er,X).

violation_14(viol(X)) <= obligatory_14(X).
-violation_14(viol(X)) <= obligatory_14(X), rexist_14(X).
exception(violation_14(X),-violation_14(X)).

violation_14(viol(X)) <= prohibited_14(X), rexist_14(X).

referTo_14(viol(X),X) <= violation_14(viol(X)).

compensate_14d_14(X) <= compensate_14(Y,X), rexist_14(Y).
exception(violation_14(viol(X)),compensate_14d_14(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_14(X) <= rexist_f_14(X).
licensee_14(X) <= licensee_f_14(X).
licensor_14(X) <= licensor_f_14(X).
product_14(X) <= product_f_14(X).
result_14(X) <= result_f_14(X).
licence_14(X) <= licence_f_14(X).
comment_14(X) <= comment_f_14(X).
isLicenceOf_14(X,Y) <= isLicenceOf_f_14(X,Y).
                
approve_14(X) <= approve_f_14(X).
commission_14(X) <= commission_f_14(X).
evaluate_14(X) <= evaluate_f_14(X).
grant_14(X) <= grant_f_14(X).
publish_14(X) <= publish_f_14(X).
remove_14(X) <= remove_f_14(X).
                
hasAgent_14(X,Y) <= hasAgent_f_14(X,Y).
hasTheme_14(X,Y) <= hasTheme_f_14(X,Y).
hasResult_14(X,Y) <= hasResult_f_14(X,Y).
hasReceiver_14(X,Y) <= hasReceiver_f_14(X,Y).
isCommentOf_14(X,Y) <= isCommentOf_f_14(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_15 to evaluate the product only with a licence; otherwise, it is prohibited_15.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_15 for the licencee to evaluate the product

prohibited_15(Ev) <= evaluate_f_15(Ev), hasAgent_f_15(Ev,X), licensee_f_15(X), hasTheme_f_15(Ev,P), product_f_15(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_15. Art.1b is an exception of Art1.a.
permitted_15(Ev) <= evaluate_f_15(Ev), hasAgent_f_15(Ev,X), licensee_f_15(X), hasTheme_f_15(Ev,P), product_f_15(P), isLicenceOf_f_15(L,P), licence_f_15(L), grant_f_15(Eg), rexist_f_15(Eg), hasTheme_f_15(Eg,L), hasAgent_f_15(Eg,Y), licensor_f_15(Y), hasReceiver_f_15(Eg,X).

exception(prohibited_15(Ev), permitted_15(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_15 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_15. If the licencee publish the results of the evaluation 
% even if this was prohibited_15, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_15 for the licencee to publish the results of the evaluation of the product
prohibited_15(Ep) <= condition_2_15(Ep,X,R).
condition_2_15(Ep,X,R) <= publish_f_15(Ep), hasAgent_f_15(Ep,X), licensee_f_15(X), hasTheme_f_15(Ep,R), result_f_15(R), hasResult_f_15(Ev,R), evaluate_f_15(Ev), rexist_f_15(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_15. Art.2b is an exception of Art2.a.
permitted_15(Ep) <= publish_f_15(Ep), hasAgent_f_15(Ep,X), licensee_f_15(X), hasTheme_f_15(Ep,R), result_f_15(R), hasResult_f_15(Ev,R), evaluate_f_15(Ev), rexist_f_15(Ev), approve_f_15(Ea), rexist_f_15(Ea), hasTheme_f_15(Ea,Ep), licensor_f_15(Y), hasAgent_f_15(Ea,Y).

exception(condition_2_15(Ep,X,R),permitted_15(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_15 to do so, he is obliged to remove them. The removal compensate_15s the violation_15 of the prohibition.
obligatory_15(ca(Ep,X,R)) <= rexist_f_15(Ep), condition_2_15(Ep,X,R).
remove_15(ca(Ep,X,R)) <= rexist_f_15(Ep), condition_2_15(Ep,X,R).
hasTheme_15(ca(Ep,X,R),R) <= rexist_f_15(Ep), condition_2_15(Ep,X,R).
hasAgent_15(ca(Ep,X,R),X) <= rexist_f_15(Ep), condition_2_15(Ep,X,R).
compensate_15(ca(Ep,X,R),Ep) <= rexist_f_15(Ep), condition_2_15(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_15 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_15.
prohibited_15(Ep) <= publish_f_15(Ep), hasAgent_f_15(Ep,X), licensee_f_15(X), hasTheme_f_15(Ep,C), comment_f_15(C), evaluate_f_15(Ev), rexist_f_15(Ev), isCommentOf_f_15(C,Ev).

% Art.3b: if publishing the result is permitted_15, also publishing the comments is permitted_15; this overrides the above prohibition.
permitted_15(Ep) <= publish_f_15(Ep), hasAgent_f_15(Ep,X), licensee_f_15(X), hasTheme_f_15(Ep,C), comment_f_15(C), isCommentOf_f_15(C,Ev), evaluate_f_15(Ev), rexist_f_15(Ev), hasResult_f_15(Ev,R), publish_f_15(Epr), hasAgent_f_15(Epr,X), hasTheme_f_15(Epr,R), permitted_15(Epr).

exception(prohibited_15(Ep),permitted_15(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_15. Art.4a is an exception of Art2.a.

obligatory_15(Ep) <= publish_f_15(Ep), hasAgent_f_15(Ep,X), licensee_f_15(X), hasTheme_f_15(Ep,R), result_f_15(R), hasResult_f_15(Ev,R), evaluate_f_15(Ev), rexist_f_15(Ev), commission_f_15(Ec), rexist_f_15(Ec), hasTheme_f_15(Ec,Ev).
exception(condition_2_15(Ep,X,R),obligatory_15(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_15 action x and, at the same time, x does not really exist => violation_15; 
%(2) if there is some prohibited_15 action x and, at the same time, x really exists => violation_15

rexist_15(ca(Ep,X,R)) <= remove_15(ca(Ep,X,R)), hasAgent_15(ca(Ep,X,R),X), hasTheme_15(ca(Ep,X,R),R), rexist_f_15(Er), remove_f_15(Er), hasTheme_f_15(Er,R), hasAgent_f_15(Er,X).

violation_15(viol(X)) <= obligatory_15(X).
-violation_15(viol(X)) <= obligatory_15(X), rexist_15(X).
exception(violation_15(X),-violation_15(X)).

violation_15(viol(X)) <= prohibited_15(X), rexist_15(X).

referTo_15(viol(X),X) <= violation_15(viol(X)).

compensate_15d_15(X) <= compensate_15(Y,X), rexist_15(Y).
exception(violation_15(viol(X)),compensate_15d_15(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_15(X) <= rexist_f_15(X).
licensee_15(X) <= licensee_f_15(X).
licensor_15(X) <= licensor_f_15(X).
product_15(X) <= product_f_15(X).
result_15(X) <= result_f_15(X).
licence_15(X) <= licence_f_15(X).
comment_15(X) <= comment_f_15(X).
isLicenceOf_15(X,Y) <= isLicenceOf_f_15(X,Y).
                
approve_15(X) <= approve_f_15(X).
commission_15(X) <= commission_f_15(X).
evaluate_15(X) <= evaluate_f_15(X).
grant_15(X) <= grant_f_15(X).
publish_15(X) <= publish_f_15(X).
remove_15(X) <= remove_f_15(X).
                
hasAgent_15(X,Y) <= hasAgent_f_15(X,Y).
hasTheme_15(X,Y) <= hasTheme_f_15(X,Y).
hasResult_15(X,Y) <= hasResult_f_15(X,Y).
hasReceiver_15(X,Y) <= hasReceiver_f_15(X,Y).
isCommentOf_15(X,Y) <= isCommentOf_f_15(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_16 to evaluate the product only with a licence; otherwise, it is prohibited_16.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_16 for the licencee to evaluate the product

prohibited_16(Ev) <= evaluate_f_16(Ev), hasAgent_f_16(Ev,X), licensee_f_16(X), hasTheme_f_16(Ev,P), product_f_16(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_16. Art.1b is an exception of Art1.a.
permitted_16(Ev) <= evaluate_f_16(Ev), hasAgent_f_16(Ev,X), licensee_f_16(X), hasTheme_f_16(Ev,P), product_f_16(P), isLicenceOf_f_16(L,P), licence_f_16(L), grant_f_16(Eg), rexist_f_16(Eg), hasTheme_f_16(Eg,L), hasAgent_f_16(Eg,Y), licensor_f_16(Y), hasReceiver_f_16(Eg,X).

exception(prohibited_16(Ev), permitted_16(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_16 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_16. If the licencee publish the results of the evaluation 
% even if this was prohibited_16, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_16 for the licencee to publish the results of the evaluation of the product
prohibited_16(Ep) <= condition_2_16(Ep,X,R).
condition_2_16(Ep,X,R) <= publish_f_16(Ep), hasAgent_f_16(Ep,X), licensee_f_16(X), hasTheme_f_16(Ep,R), result_f_16(R), hasResult_f_16(Ev,R), evaluate_f_16(Ev), rexist_f_16(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_16. Art.2b is an exception of Art2.a.
permitted_16(Ep) <= publish_f_16(Ep), hasAgent_f_16(Ep,X), licensee_f_16(X), hasTheme_f_16(Ep,R), result_f_16(R), hasResult_f_16(Ev,R), evaluate_f_16(Ev), rexist_f_16(Ev), approve_f_16(Ea), rexist_f_16(Ea), hasTheme_f_16(Ea,Ep), licensor_f_16(Y), hasAgent_f_16(Ea,Y).

exception(condition_2_16(Ep,X,R),permitted_16(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_16 to do so, he is obliged to remove them. The removal compensate_16s the violation_16 of the prohibition.
obligatory_16(ca(Ep,X,R)) <= rexist_f_16(Ep), condition_2_16(Ep,X,R).
remove_16(ca(Ep,X,R)) <= rexist_f_16(Ep), condition_2_16(Ep,X,R).
hasTheme_16(ca(Ep,X,R),R) <= rexist_f_16(Ep), condition_2_16(Ep,X,R).
hasAgent_16(ca(Ep,X,R),X) <= rexist_f_16(Ep), condition_2_16(Ep,X,R).
compensate_16(ca(Ep,X,R),Ep) <= rexist_f_16(Ep), condition_2_16(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_16 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_16.
prohibited_16(Ep) <= publish_f_16(Ep), hasAgent_f_16(Ep,X), licensee_f_16(X), hasTheme_f_16(Ep,C), comment_f_16(C), evaluate_f_16(Ev), rexist_f_16(Ev), isCommentOf_f_16(C,Ev).

% Art.3b: if publishing the result is permitted_16, also publishing the comments is permitted_16; this overrides the above prohibition.
permitted_16(Ep) <= publish_f_16(Ep), hasAgent_f_16(Ep,X), licensee_f_16(X), hasTheme_f_16(Ep,C), comment_f_16(C), isCommentOf_f_16(C,Ev), evaluate_f_16(Ev), rexist_f_16(Ev), hasResult_f_16(Ev,R), publish_f_16(Epr), hasAgent_f_16(Epr,X), hasTheme_f_16(Epr,R), permitted_16(Epr).

exception(prohibited_16(Ep),permitted_16(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_16. Art.4a is an exception of Art2.a.

obligatory_16(Ep) <= publish_f_16(Ep), hasAgent_f_16(Ep,X), licensee_f_16(X), hasTheme_f_16(Ep,R), result_f_16(R), hasResult_f_16(Ev,R), evaluate_f_16(Ev), rexist_f_16(Ev), commission_f_16(Ec), rexist_f_16(Ec), hasTheme_f_16(Ec,Ev).
exception(condition_2_16(Ep,X,R),obligatory_16(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_16 action x and, at the same time, x does not really exist => violation_16; 
%(2) if there is some prohibited_16 action x and, at the same time, x really exists => violation_16

rexist_16(ca(Ep,X,R)) <= remove_16(ca(Ep,X,R)), hasAgent_16(ca(Ep,X,R),X), hasTheme_16(ca(Ep,X,R),R), rexist_f_16(Er), remove_f_16(Er), hasTheme_f_16(Er,R), hasAgent_f_16(Er,X).

violation_16(viol(X)) <= obligatory_16(X).
-violation_16(viol(X)) <= obligatory_16(X), rexist_16(X).
exception(violation_16(X),-violation_16(X)).

violation_16(viol(X)) <= prohibited_16(X), rexist_16(X).

referTo_16(viol(X),X) <= violation_16(viol(X)).

compensate_16d_16(X) <= compensate_16(Y,X), rexist_16(Y).
exception(violation_16(viol(X)),compensate_16d_16(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_16(X) <= rexist_f_16(X).
licensee_16(X) <= licensee_f_16(X).
licensor_16(X) <= licensor_f_16(X).
product_16(X) <= product_f_16(X).
result_16(X) <= result_f_16(X).
licence_16(X) <= licence_f_16(X).
comment_16(X) <= comment_f_16(X).
isLicenceOf_16(X,Y) <= isLicenceOf_f_16(X,Y).
                
approve_16(X) <= approve_f_16(X).
commission_16(X) <= commission_f_16(X).
evaluate_16(X) <= evaluate_f_16(X).
grant_16(X) <= grant_f_16(X).
publish_16(X) <= publish_f_16(X).
remove_16(X) <= remove_f_16(X).
                
hasAgent_16(X,Y) <= hasAgent_f_16(X,Y).
hasTheme_16(X,Y) <= hasTheme_f_16(X,Y).
hasResult_16(X,Y) <= hasResult_f_16(X,Y).
hasReceiver_16(X,Y) <= hasReceiver_f_16(X,Y).
isCommentOf_16(X,Y) <= isCommentOf_f_16(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_17 to evaluate the product only with a licence; otherwise, it is prohibited_17.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_17 for the licencee to evaluate the product

prohibited_17(Ev) <= evaluate_f_17(Ev), hasAgent_f_17(Ev,X), licensee_f_17(X), hasTheme_f_17(Ev,P), product_f_17(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_17. Art.1b is an exception of Art1.a.
permitted_17(Ev) <= evaluate_f_17(Ev), hasAgent_f_17(Ev,X), licensee_f_17(X), hasTheme_f_17(Ev,P), product_f_17(P), isLicenceOf_f_17(L,P), licence_f_17(L), grant_f_17(Eg), rexist_f_17(Eg), hasTheme_f_17(Eg,L), hasAgent_f_17(Eg,Y), licensor_f_17(Y), hasReceiver_f_17(Eg,X).

exception(prohibited_17(Ev), permitted_17(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_17 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_17. If the licencee publish the results of the evaluation 
% even if this was prohibited_17, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_17 for the licencee to publish the results of the evaluation of the product
prohibited_17(Ep) <= condition_2_17(Ep,X,R).
condition_2_17(Ep,X,R) <= publish_f_17(Ep), hasAgent_f_17(Ep,X), licensee_f_17(X), hasTheme_f_17(Ep,R), result_f_17(R), hasResult_f_17(Ev,R), evaluate_f_17(Ev), rexist_f_17(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_17. Art.2b is an exception of Art2.a.
permitted_17(Ep) <= publish_f_17(Ep), hasAgent_f_17(Ep,X), licensee_f_17(X), hasTheme_f_17(Ep,R), result_f_17(R), hasResult_f_17(Ev,R), evaluate_f_17(Ev), rexist_f_17(Ev), approve_f_17(Ea), rexist_f_17(Ea), hasTheme_f_17(Ea,Ep), licensor_f_17(Y), hasAgent_f_17(Ea,Y).

exception(condition_2_17(Ep,X,R),permitted_17(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_17 to do so, he is obliged to remove them. The removal compensate_17s the violation_17 of the prohibition.
obligatory_17(ca(Ep,X,R)) <= rexist_f_17(Ep), condition_2_17(Ep,X,R).
remove_17(ca(Ep,X,R)) <= rexist_f_17(Ep), condition_2_17(Ep,X,R).
hasTheme_17(ca(Ep,X,R),R) <= rexist_f_17(Ep), condition_2_17(Ep,X,R).
hasAgent_17(ca(Ep,X,R),X) <= rexist_f_17(Ep), condition_2_17(Ep,X,R).
compensate_17(ca(Ep,X,R),Ep) <= rexist_f_17(Ep), condition_2_17(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_17 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_17.
prohibited_17(Ep) <= publish_f_17(Ep), hasAgent_f_17(Ep,X), licensee_f_17(X), hasTheme_f_17(Ep,C), comment_f_17(C), evaluate_f_17(Ev), rexist_f_17(Ev), isCommentOf_f_17(C,Ev).

% Art.3b: if publishing the result is permitted_17, also publishing the comments is permitted_17; this overrides the above prohibition.
permitted_17(Ep) <= publish_f_17(Ep), hasAgent_f_17(Ep,X), licensee_f_17(X), hasTheme_f_17(Ep,C), comment_f_17(C), isCommentOf_f_17(C,Ev), evaluate_f_17(Ev), rexist_f_17(Ev), hasResult_f_17(Ev,R), publish_f_17(Epr), hasAgent_f_17(Epr,X), hasTheme_f_17(Epr,R), permitted_17(Epr).

exception(prohibited_17(Ep),permitted_17(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_17. Art.4a is an exception of Art2.a.

obligatory_17(Ep) <= publish_f_17(Ep), hasAgent_f_17(Ep,X), licensee_f_17(X), hasTheme_f_17(Ep,R), result_f_17(R), hasResult_f_17(Ev,R), evaluate_f_17(Ev), rexist_f_17(Ev), commission_f_17(Ec), rexist_f_17(Ec), hasTheme_f_17(Ec,Ev).
exception(condition_2_17(Ep,X,R),obligatory_17(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_17 action x and, at the same time, x does not really exist => violation_17; 
%(2) if there is some prohibited_17 action x and, at the same time, x really exists => violation_17

rexist_17(ca(Ep,X,R)) <= remove_17(ca(Ep,X,R)), hasAgent_17(ca(Ep,X,R),X), hasTheme_17(ca(Ep,X,R),R), rexist_f_17(Er), remove_f_17(Er), hasTheme_f_17(Er,R), hasAgent_f_17(Er,X).

violation_17(viol(X)) <= obligatory_17(X).
-violation_17(viol(X)) <= obligatory_17(X), rexist_17(X).
exception(violation_17(X),-violation_17(X)).

violation_17(viol(X)) <= prohibited_17(X), rexist_17(X).

referTo_17(viol(X),X) <= violation_17(viol(X)).

compensate_17d_17(X) <= compensate_17(Y,X), rexist_17(Y).
exception(violation_17(viol(X)),compensate_17d_17(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_17(X) <= rexist_f_17(X).
licensee_17(X) <= licensee_f_17(X).
licensor_17(X) <= licensor_f_17(X).
product_17(X) <= product_f_17(X).
result_17(X) <= result_f_17(X).
licence_17(X) <= licence_f_17(X).
comment_17(X) <= comment_f_17(X).
isLicenceOf_17(X,Y) <= isLicenceOf_f_17(X,Y).
                
approve_17(X) <= approve_f_17(X).
commission_17(X) <= commission_f_17(X).
evaluate_17(X) <= evaluate_f_17(X).
grant_17(X) <= grant_f_17(X).
publish_17(X) <= publish_f_17(X).
remove_17(X) <= remove_f_17(X).
                
hasAgent_17(X,Y) <= hasAgent_f_17(X,Y).
hasTheme_17(X,Y) <= hasTheme_f_17(X,Y).
hasResult_17(X,Y) <= hasResult_f_17(X,Y).
hasReceiver_17(X,Y) <= hasReceiver_f_17(X,Y).
isCommentOf_17(X,Y) <= isCommentOf_f_17(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_18 to evaluate the product only with a licence; otherwise, it is prohibited_18.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_18 for the licencee to evaluate the product

prohibited_18(Ev) <= evaluate_f_18(Ev), hasAgent_f_18(Ev,X), licensee_f_18(X), hasTheme_f_18(Ev,P), product_f_18(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_18. Art.1b is an exception of Art1.a.
permitted_18(Ev) <= evaluate_f_18(Ev), hasAgent_f_18(Ev,X), licensee_f_18(X), hasTheme_f_18(Ev,P), product_f_18(P), isLicenceOf_f_18(L,P), licence_f_18(L), grant_f_18(Eg), rexist_f_18(Eg), hasTheme_f_18(Eg,L), hasAgent_f_18(Eg,Y), licensor_f_18(Y), hasReceiver_f_18(Eg,X).

exception(prohibited_18(Ev), permitted_18(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_18 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_18. If the licencee publish the results of the evaluation 
% even if this was prohibited_18, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_18 for the licencee to publish the results of the evaluation of the product
prohibited_18(Ep) <= condition_2_18(Ep,X,R).
condition_2_18(Ep,X,R) <= publish_f_18(Ep), hasAgent_f_18(Ep,X), licensee_f_18(X), hasTheme_f_18(Ep,R), result_f_18(R), hasResult_f_18(Ev,R), evaluate_f_18(Ev), rexist_f_18(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_18. Art.2b is an exception of Art2.a.
permitted_18(Ep) <= publish_f_18(Ep), hasAgent_f_18(Ep,X), licensee_f_18(X), hasTheme_f_18(Ep,R), result_f_18(R), hasResult_f_18(Ev,R), evaluate_f_18(Ev), rexist_f_18(Ev), approve_f_18(Ea), rexist_f_18(Ea), hasTheme_f_18(Ea,Ep), licensor_f_18(Y), hasAgent_f_18(Ea,Y).

exception(condition_2_18(Ep,X,R),permitted_18(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_18 to do so, he is obliged to remove them. The removal compensate_18s the violation_18 of the prohibition.
obligatory_18(ca(Ep,X,R)) <= rexist_f_18(Ep), condition_2_18(Ep,X,R).
remove_18(ca(Ep,X,R)) <= rexist_f_18(Ep), condition_2_18(Ep,X,R).
hasTheme_18(ca(Ep,X,R),R) <= rexist_f_18(Ep), condition_2_18(Ep,X,R).
hasAgent_18(ca(Ep,X,R),X) <= rexist_f_18(Ep), condition_2_18(Ep,X,R).
compensate_18(ca(Ep,X,R),Ep) <= rexist_f_18(Ep), condition_2_18(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_18 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_18.
prohibited_18(Ep) <= publish_f_18(Ep), hasAgent_f_18(Ep,X), licensee_f_18(X), hasTheme_f_18(Ep,C), comment_f_18(C), evaluate_f_18(Ev), rexist_f_18(Ev), isCommentOf_f_18(C,Ev).

% Art.3b: if publishing the result is permitted_18, also publishing the comments is permitted_18; this overrides the above prohibition.
permitted_18(Ep) <= publish_f_18(Ep), hasAgent_f_18(Ep,X), licensee_f_18(X), hasTheme_f_18(Ep,C), comment_f_18(C), isCommentOf_f_18(C,Ev), evaluate_f_18(Ev), rexist_f_18(Ev), hasResult_f_18(Ev,R), publish_f_18(Epr), hasAgent_f_18(Epr,X), hasTheme_f_18(Epr,R), permitted_18(Epr).

exception(prohibited_18(Ep),permitted_18(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_18. Art.4a is an exception of Art2.a.

obligatory_18(Ep) <= publish_f_18(Ep), hasAgent_f_18(Ep,X), licensee_f_18(X), hasTheme_f_18(Ep,R), result_f_18(R), hasResult_f_18(Ev,R), evaluate_f_18(Ev), rexist_f_18(Ev), commission_f_18(Ec), rexist_f_18(Ec), hasTheme_f_18(Ec,Ev).
exception(condition_2_18(Ep,X,R),obligatory_18(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_18 action x and, at the same time, x does not really exist => violation_18; 
%(2) if there is some prohibited_18 action x and, at the same time, x really exists => violation_18

rexist_18(ca(Ep,X,R)) <= remove_18(ca(Ep,X,R)), hasAgent_18(ca(Ep,X,R),X), hasTheme_18(ca(Ep,X,R),R), rexist_f_18(Er), remove_f_18(Er), hasTheme_f_18(Er,R), hasAgent_f_18(Er,X).

violation_18(viol(X)) <= obligatory_18(X).
-violation_18(viol(X)) <= obligatory_18(X), rexist_18(X).
exception(violation_18(X),-violation_18(X)).

violation_18(viol(X)) <= prohibited_18(X), rexist_18(X).

referTo_18(viol(X),X) <= violation_18(viol(X)).

compensate_18d_18(X) <= compensate_18(Y,X), rexist_18(Y).
exception(violation_18(viol(X)),compensate_18d_18(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_18(X) <= rexist_f_18(X).
licensee_18(X) <= licensee_f_18(X).
licensor_18(X) <= licensor_f_18(X).
product_18(X) <= product_f_18(X).
result_18(X) <= result_f_18(X).
licence_18(X) <= licence_f_18(X).
comment_18(X) <= comment_f_18(X).
isLicenceOf_18(X,Y) <= isLicenceOf_f_18(X,Y).
                
approve_18(X) <= approve_f_18(X).
commission_18(X) <= commission_f_18(X).
evaluate_18(X) <= evaluate_f_18(X).
grant_18(X) <= grant_f_18(X).
publish_18(X) <= publish_f_18(X).
remove_18(X) <= remove_f_18(X).
                
hasAgent_18(X,Y) <= hasAgent_f_18(X,Y).
hasTheme_18(X,Y) <= hasTheme_f_18(X,Y).
hasResult_18(X,Y) <= hasResult_f_18(X,Y).
hasReceiver_18(X,Y) <= hasReceiver_f_18(X,Y).
isCommentOf_18(X,Y) <= isCommentOf_f_18(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_19 to evaluate the product only with a licence; otherwise, it is prohibited_19.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_19 for the licencee to evaluate the product

prohibited_19(Ev) <= evaluate_f_19(Ev), hasAgent_f_19(Ev,X), licensee_f_19(X), hasTheme_f_19(Ev,P), product_f_19(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_19. Art.1b is an exception of Art1.a.
permitted_19(Ev) <= evaluate_f_19(Ev), hasAgent_f_19(Ev,X), licensee_f_19(X), hasTheme_f_19(Ev,P), product_f_19(P), isLicenceOf_f_19(L,P), licence_f_19(L), grant_f_19(Eg), rexist_f_19(Eg), hasTheme_f_19(Eg,L), hasAgent_f_19(Eg,Y), licensor_f_19(Y), hasReceiver_f_19(Eg,X).

exception(prohibited_19(Ev), permitted_19(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_19 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_19. If the licencee publish the results of the evaluation 
% even if this was prohibited_19, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_19 for the licencee to publish the results of the evaluation of the product
prohibited_19(Ep) <= condition_2_19(Ep,X,R).
condition_2_19(Ep,X,R) <= publish_f_19(Ep), hasAgent_f_19(Ep,X), licensee_f_19(X), hasTheme_f_19(Ep,R), result_f_19(R), hasResult_f_19(Ev,R), evaluate_f_19(Ev), rexist_f_19(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_19. Art.2b is an exception of Art2.a.
permitted_19(Ep) <= publish_f_19(Ep), hasAgent_f_19(Ep,X), licensee_f_19(X), hasTheme_f_19(Ep,R), result_f_19(R), hasResult_f_19(Ev,R), evaluate_f_19(Ev), rexist_f_19(Ev), approve_f_19(Ea), rexist_f_19(Ea), hasTheme_f_19(Ea,Ep), licensor_f_19(Y), hasAgent_f_19(Ea,Y).

exception(condition_2_19(Ep,X,R),permitted_19(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_19 to do so, he is obliged to remove them. The removal compensate_19s the violation_19 of the prohibition.
obligatory_19(ca(Ep,X,R)) <= rexist_f_19(Ep), condition_2_19(Ep,X,R).
remove_19(ca(Ep,X,R)) <= rexist_f_19(Ep), condition_2_19(Ep,X,R).
hasTheme_19(ca(Ep,X,R),R) <= rexist_f_19(Ep), condition_2_19(Ep,X,R).
hasAgent_19(ca(Ep,X,R),X) <= rexist_f_19(Ep), condition_2_19(Ep,X,R).
compensate_19(ca(Ep,X,R),Ep) <= rexist_f_19(Ep), condition_2_19(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_19 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_19.
prohibited_19(Ep) <= publish_f_19(Ep), hasAgent_f_19(Ep,X), licensee_f_19(X), hasTheme_f_19(Ep,C), comment_f_19(C), evaluate_f_19(Ev), rexist_f_19(Ev), isCommentOf_f_19(C,Ev).

% Art.3b: if publishing the result is permitted_19, also publishing the comments is permitted_19; this overrides the above prohibition.
permitted_19(Ep) <= publish_f_19(Ep), hasAgent_f_19(Ep,X), licensee_f_19(X), hasTheme_f_19(Ep,C), comment_f_19(C), isCommentOf_f_19(C,Ev), evaluate_f_19(Ev), rexist_f_19(Ev), hasResult_f_19(Ev,R), publish_f_19(Epr), hasAgent_f_19(Epr,X), hasTheme_f_19(Epr,R), permitted_19(Epr).

exception(prohibited_19(Ep),permitted_19(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_19. Art.4a is an exception of Art2.a.

obligatory_19(Ep) <= publish_f_19(Ep), hasAgent_f_19(Ep,X), licensee_f_19(X), hasTheme_f_19(Ep,R), result_f_19(R), hasResult_f_19(Ev,R), evaluate_f_19(Ev), rexist_f_19(Ev), commission_f_19(Ec), rexist_f_19(Ec), hasTheme_f_19(Ec,Ev).
exception(condition_2_19(Ep,X,R),obligatory_19(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_19 action x and, at the same time, x does not really exist => violation_19; 
%(2) if there is some prohibited_19 action x and, at the same time, x really exists => violation_19

rexist_19(ca(Ep,X,R)) <= remove_19(ca(Ep,X,R)), hasAgent_19(ca(Ep,X,R),X), hasTheme_19(ca(Ep,X,R),R), rexist_f_19(Er), remove_f_19(Er), hasTheme_f_19(Er,R), hasAgent_f_19(Er,X).

violation_19(viol(X)) <= obligatory_19(X).
-violation_19(viol(X)) <= obligatory_19(X), rexist_19(X).
exception(violation_19(X),-violation_19(X)).

violation_19(viol(X)) <= prohibited_19(X), rexist_19(X).

referTo_19(viol(X),X) <= violation_19(viol(X)).

compensate_19d_19(X) <= compensate_19(Y,X), rexist_19(Y).
exception(violation_19(viol(X)),compensate_19d_19(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_19(X) <= rexist_f_19(X).
licensee_19(X) <= licensee_f_19(X).
licensor_19(X) <= licensor_f_19(X).
product_19(X) <= product_f_19(X).
result_19(X) <= result_f_19(X).
licence_19(X) <= licence_f_19(X).
comment_19(X) <= comment_f_19(X).
isLicenceOf_19(X,Y) <= isLicenceOf_f_19(X,Y).
                
approve_19(X) <= approve_f_19(X).
commission_19(X) <= commission_f_19(X).
evaluate_19(X) <= evaluate_f_19(X).
grant_19(X) <= grant_f_19(X).
publish_19(X) <= publish_f_19(X).
remove_19(X) <= remove_f_19(X).
                
hasAgent_19(X,Y) <= hasAgent_f_19(X,Y).
hasTheme_19(X,Y) <= hasTheme_f_19(X,Y).
hasResult_19(X,Y) <= hasResult_f_19(X,Y).
hasReceiver_19(X,Y) <= hasReceiver_f_19(X,Y).
isCommentOf_19(X,Y) <= isCommentOf_f_19(X,Y).
