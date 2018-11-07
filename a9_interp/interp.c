#include <setjmp.h>
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include "interp.h"

void *closurer_clos(void *body, void *env) {
closure* _data = (closure*)malloc(sizeof(closure));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _clos_closure;
  _data->u._clos._body = body;
  _data->u._clos._env = env;
  return (void *)_data;
}

void *envr_r_emptyr__m__env() {
envr_* _data = (envr_*)malloc(sizeof(envr_));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _emptyr__m__env_envr_;
  return (void *)_data;
}

void *envr_r_newenv(void *envr__ex__, void *objr__ex__) {
envr_* _data = (envr_*)malloc(sizeof(envr_));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _newenv_envr_;
  _data->u._newenv._envr__ex__ = envr__ex__;
  _data->u._newenv._objr__ex__ = objr__ex__;
  return (void *)_data;
}

void *contr_multr__m__innerr__m__k(void *rr1r__ex__, void *kr__ex__) {
cont* _data = (cont*)malloc(sizeof(cont));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _multr__m__innerr__m__k_cont;
  _data->u._multr__m__innerr__m__k._rr1r__ex__ = rr1r__ex__;
  _data->u._multr__m__innerr__m__k._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *contr_multr__m__outerr__m__k(void *xr2r__ex__, void *envr__ex__, void *kr__ex__) {
cont* _data = (cont*)malloc(sizeof(cont));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _multr__m__outerr__m__k_cont;
  _data->u._multr__m__outerr__m__k._xr2r__ex__ = xr2r__ex__;
  _data->u._multr__m__outerr__m__k._envr__ex__ = envr__ex__;
  _data->u._multr__m__outerr__m__k._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *contr_subr__m__k(void *kr__ex__) {
cont* _data = (cont*)malloc(sizeof(cont));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _subr__m__k_cont;
  _data->u._subr__m__k._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *contr_zeror__m__k(void *kr__ex__) {
cont* _data = (cont*)malloc(sizeof(cont));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _zeror__m__k_cont;
  _data->u._zeror__m__k._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *contr_ifr__m__k(void *conseqr__ex__, void *altr__ex__, void *envr__ex__, void *kr__ex__) {
cont* _data = (cont*)malloc(sizeof(cont));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _ifr__m__k_cont;
  _data->u._ifr__m__k._conseqr__ex__ = conseqr__ex__;
  _data->u._ifr__m__k._altr__ex__ = altr__ex__;
  _data->u._ifr__m__k._envr__ex__ = envr__ex__;
  _data->u._ifr__m__k._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *contr_throwr__m__k(void *vr__m__expr__ex__, void *envr__ex__) {
cont* _data = (cont*)malloc(sizeof(cont));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _throwr__m__k_cont;
  _data->u._throwr__m__k._vr__m__expr__ex__ = vr__m__expr__ex__;
  _data->u._throwr__m__k._envr__ex__ = envr__ex__;
  return (void *)_data;
}

void *contr_letr__m__k(void *bodyr__ex__, void *envr__ex__, void *kr__ex__) {
cont* _data = (cont*)malloc(sizeof(cont));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _letr__m__k_cont;
  _data->u._letr__m__k._bodyr__ex__ = bodyr__ex__;
  _data->u._letr__m__k._envr__ex__ = envr__ex__;
  _data->u._letr__m__k._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *contr_appr__m__innerr__m__k(void *ratorr__ex__, void *kr__ex__) {
cont* _data = (cont*)malloc(sizeof(cont));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _appr__m__innerr__m__k_cont;
  _data->u._appr__m__innerr__m__k._ratorr__ex__ = ratorr__ex__;
  _data->u._appr__m__innerr__m__k._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *contr_appr__m__outerr__m__k(void *randr__ex__, void *envr__ex__, void *kr__ex__) {
cont* _data = (cont*)malloc(sizeof(cont));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _appr__m__outerr__m__k_cont;
  _data->u._appr__m__outerr__m__k._randr__ex__ = randr__ex__;
  _data->u._appr__m__outerr__m__k._envr__ex__ = envr__ex__;
  _data->u._appr__m__outerr__m__k._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *contr_emptyr__m__k(void *jumpout) {
cont* _data = (cont*)malloc(sizeof(cont));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _emptyr__m__k_cont;
  _data->u._emptyr__m__k._jumpout = jumpout;
  return (void *)_data;
}

void *exprr_const(void *cexp) {
expr* _data = (expr*)malloc(sizeof(expr));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _const_expr;
  _data->u._const._cexp = cexp;
  return (void *)_data;
}

void *exprr_var(void *n) {
expr* _data = (expr*)malloc(sizeof(expr));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _var_expr;
  _data->u._var._n = n;
  return (void *)_data;
}

void *exprr_if(void *test, void *conseq, void *alt) {
expr* _data = (expr*)malloc(sizeof(expr));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _if_expr;
  _data->u._if._test = test;
  _data->u._if._conseq = conseq;
  _data->u._if._alt = alt;
  return (void *)_data;
}

void *exprr_mult(void *nexpr1, void *nexpr2) {
expr* _data = (expr*)malloc(sizeof(expr));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _mult_expr;
  _data->u._mult._nexpr1 = nexpr1;
  _data->u._mult._nexpr2 = nexpr2;
  return (void *)_data;
}

void *exprr_subr1(void *nexp) {
expr* _data = (expr*)malloc(sizeof(expr));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _subr1_expr;
  _data->u._subr1._nexp = nexp;
  return (void *)_data;
}

void *exprr_zero(void *nexp) {
expr* _data = (expr*)malloc(sizeof(expr));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _zero_expr;
  _data->u._zero._nexp = nexp;
  return (void *)_data;
}

void *exprr_letcc(void *body) {
expr* _data = (expr*)malloc(sizeof(expr));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _letcc_expr;
  _data->u._letcc._body = body;
  return (void *)_data;
}

void *exprr_throw(void *kexp, void *vexp) {
expr* _data = (expr*)malloc(sizeof(expr));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _throw_expr;
  _data->u._throw._kexp = kexp;
  _data->u._throw._vexp = vexp;
  return (void *)_data;
}

void *exprr_let(void *exp, void *body) {
expr* _data = (expr*)malloc(sizeof(expr));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _let_expr;
  _data->u._let._exp = exp;
  _data->u._let._body = body;
  return (void *)_data;
}

void *exprr_lambda(void *body) {
expr* _data = (expr*)malloc(sizeof(expr));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _lambda_expr;
  _data->u._lambda._body = body;
  return (void *)_data;
}

void *exprr_app(void *rator, void *rand) {
expr* _data = (expr*)malloc(sizeof(expr));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _app_expr;
  _data->u._app._rator = rator;
  _data->u._app._rand = rand;
  return (void *)_data;
}

int main()
{
expr__t__ = (void *)exprr_let(exprr_lambda(exprr_lambda(exprr_if(exprr_zero(exprr_var((void *)0)),exprr_const((void *)1),exprr_mult(exprr_var((void *)0),exprr_app(exprr_app(exprr_var((void *)1),exprr_var((void *)1)),exprr_subr1(exprr_var((void *)0))))))),exprr_mult(exprr_letcc(exprr_app(exprr_app(exprr_var((void *)1),exprr_var((void *)1)),exprr_throw(exprr_var((void *)0),exprr_app(exprr_app(exprr_var((void *)1),exprr_var((void *)1)),exprr_const((void *)4))))),exprr_const((void *)5)));
vocenvr__t__ = (void *)envr_r_emptyr__m__env();
pc = &valuer__m__ofr__m__cps;
mount_tram();
printf("Fact 5: %d\n", (int)vr__t__);}

void applyr__m__closure()
{
closure* _c = (closure*)closr__t__;
switch (_c->tag) {
case _clos_closure: {
void *body = _c->u._clos._body;
void *env = _c->u._clos._env;
expr__t__ = (void *)body;
vocenvr__t__ = (void *)envr_r_newenv(env,xr__t__);
vockr__t__ = (void *)ackr__t__;
pc = &valuer__m__ofr__m__cps;
break; }
}
}

void applyr__m__env()
{
envr_* _c = (envr_*)aeenvr__t__;
switch (_c->tag) {
case _emptyr__m__env_envr_: {
fprintf(stderr, "unbound identifier");
 exit(1);
break; }
case _newenv_envr_: {
void *envr__ex__ = _c->u._newenv._envr__ex__;
void *objr__ex__ = _c->u._newenv._objr__ex__;
if((addrr__t__ == 0)) {
  akkr__t__ = (void *)aekr__t__;
vr__t__ = (void *)objr__ex__;
pc = &applyr__m__k;

} else {
  aeenvr__t__ = (void *)envr__ex__;
addrr__t__ = (void *)(void *)((int)addrr__t__ - 1);
pc = &applyr__m__env;

}
break; }
}
}

void valuer__m__ofr__m__cps()
{
expr* _c = (expr*)expr__t__;
switch (_c->tag) {
case _const_expr: {
void *exp = _c->u._const._cexp;
akkr__t__ = (void *)vockr__t__;
vr__t__ = (void *)exp;
pc = &applyr__m__k;
break; }
case _mult_expr: {
void *xr1 = _c->u._mult._nexpr1;
void *xr2 = _c->u._mult._nexpr2;
expr__t__ = (void *)xr1;
vockr__t__ = (void *)contr_multr__m__outerr__m__k(xr2,vocenvr__t__,vockr__t__);
pc = &valuer__m__ofr__m__cps;
break; }
case _subr1_expr: {
void *x = _c->u._subr1._nexp;
expr__t__ = (void *)x;
vockr__t__ = (void *)contr_subr__m__k(vockr__t__);
pc = &valuer__m__ofr__m__cps;
break; }
case _zero_expr: {
void *x = _c->u._zero._nexp;
expr__t__ = (void *)x;
vockr__t__ = (void *)contr_zeror__m__k(vockr__t__);
pc = &valuer__m__ofr__m__cps;
break; }
case _if_expr: {
void *test = _c->u._if._test;
void *conseq = _c->u._if._conseq;
void *alt = _c->u._if._alt;
expr__t__ = (void *)test;
vockr__t__ = (void *)contr_ifr__m__k(conseq,alt,vocenvr__t__,vockr__t__);
pc = &valuer__m__ofr__m__cps;
break; }
case _letcc_expr: {
void *body = _c->u._letcc._body;
expr__t__ = (void *)body;
vocenvr__t__ = (void *)envr_r_newenv(vocenvr__t__,vockr__t__);
pc = &valuer__m__ofr__m__cps;
break; }
case _throw_expr: {
void *kr__m__exp = _c->u._throw._kexp;
void *vr__m__exp = _c->u._throw._vexp;
expr__t__ = (void *)kr__m__exp;
vockr__t__ = (void *)contr_throwr__m__k(vr__m__exp,vocenvr__t__);
pc = &valuer__m__ofr__m__cps;
break; }
case _let_expr: {
void *e = _c->u._let._exp;
void *body = _c->u._let._body;
expr__t__ = (void *)e;
vockr__t__ = (void *)contr_letr__m__k(body,vocenvr__t__,vockr__t__);
pc = &valuer__m__ofr__m__cps;
break; }
case _var_expr: {
void *exp = _c->u._var._n;
aeenvr__t__ = (void *)vocenvr__t__;
addrr__t__ = (void *)exp;
aekr__t__ = (void *)vockr__t__;
pc = &applyr__m__env;
break; }
case _lambda_expr: {
void *body = _c->u._lambda._body;
akkr__t__ = (void *)vockr__t__;
vr__t__ = (void *)closurer_clos(body,vocenvr__t__);
pc = &applyr__m__k;
break; }
case _app_expr: {
void *rator = _c->u._app._rator;
void *rand = _c->u._app._rand;
expr__t__ = (void *)rator;
vockr__t__ = (void *)contr_appr__m__outerr__m__k(rand,vocenvr__t__,vockr__t__);
pc = &valuer__m__ofr__m__cps;
break; }
}
}

void applyr__m__k()
{
cont* _c = (cont*)akkr__t__;
switch (_c->tag) {
case _multr__m__innerr__m__k_cont: {
void *rr1r__ex__ = _c->u._multr__m__innerr__m__k._rr1r__ex__;
void *kr__ex__ = _c->u._multr__m__innerr__m__k._kr__ex__;
akkr__t__ = (void *)kr__ex__;
vr__t__ = (void *)(void *)((int)rr1r__ex__ * (int)vr__t__);
pc = &applyr__m__k;
break; }
case _multr__m__outerr__m__k_cont: {
void *xr2r__ex__ = _c->u._multr__m__outerr__m__k._xr2r__ex__;
void *envr__ex__ = _c->u._multr__m__outerr__m__k._envr__ex__;
void *kr__ex__ = _c->u._multr__m__outerr__m__k._kr__ex__;
expr__t__ = (void *)xr2r__ex__;
vocenvr__t__ = (void *)envr__ex__;
vockr__t__ = (void *)contr_multr__m__innerr__m__k(vr__t__,kr__ex__);
pc = &valuer__m__ofr__m__cps;
break; }
case _subr__m__k_cont: {
void *kr__ex__ = _c->u._subr__m__k._kr__ex__;
akkr__t__ = (void *)kr__ex__;
vr__t__ = (void *)(void *)((int)vr__t__ - 1);
pc = &applyr__m__k;
break; }
case _zeror__m__k_cont: {
void *kr__ex__ = _c->u._zeror__m__k._kr__ex__;
akkr__t__ = (void *)kr__ex__;
vr__t__ = (void *)(vr__t__ == 0);
pc = &applyr__m__k;
break; }
case _ifr__m__k_cont: {
void *conseqr__ex__ = _c->u._ifr__m__k._conseqr__ex__;
void *altr__ex__ = _c->u._ifr__m__k._altr__ex__;
void *envr__ex__ = _c->u._ifr__m__k._envr__ex__;
void *kr__ex__ = _c->u._ifr__m__k._kr__ex__;
if(vr__t__) {
  expr__t__ = (void *)conseqr__ex__;
vocenvr__t__ = (void *)envr__ex__;
vockr__t__ = (void *)kr__ex__;
pc = &valuer__m__ofr__m__cps;

} else {
  expr__t__ = (void *)altr__ex__;
vocenvr__t__ = (void *)envr__ex__;
vockr__t__ = (void *)kr__ex__;
pc = &valuer__m__ofr__m__cps;

}
break; }
case _throwr__m__k_cont: {
void *vr__m__expr__ex__ = _c->u._throwr__m__k._vr__m__expr__ex__;
void *envr__ex__ = _c->u._throwr__m__k._envr__ex__;
expr__t__ = (void *)vr__m__expr__ex__;
vocenvr__t__ = (void *)envr__ex__;
vockr__t__ = (void *)vr__t__;
pc = &valuer__m__ofr__m__cps;
break; }
case _letr__m__k_cont: {
void *bodyr__ex__ = _c->u._letr__m__k._bodyr__ex__;
void *envr__ex__ = _c->u._letr__m__k._envr__ex__;
void *kr__ex__ = _c->u._letr__m__k._kr__ex__;
expr__t__ = (void *)bodyr__ex__;
vocenvr__t__ = (void *)envr_r_newenv(envr__ex__,vr__t__);
vockr__t__ = (void *)kr__ex__;
pc = &valuer__m__ofr__m__cps;
break; }
case _appr__m__innerr__m__k_cont: {
void *ratorr__ex__ = _c->u._appr__m__innerr__m__k._ratorr__ex__;
void *kr__ex__ = _c->u._appr__m__innerr__m__k._kr__ex__;
closr__t__ = (void *)ratorr__ex__;
xr__t__ = (void *)vr__t__;
ackr__t__ = (void *)kr__ex__;
pc = &applyr__m__closure;
break; }
case _appr__m__outerr__m__k_cont: {
void *randr__ex__ = _c->u._appr__m__outerr__m__k._randr__ex__;
void *envr__ex__ = _c->u._appr__m__outerr__m__k._envr__ex__;
void *kr__ex__ = _c->u._appr__m__outerr__m__k._kr__ex__;
expr__t__ = (void *)randr__ex__;
vocenvr__t__ = (void *)envr__ex__;
vockr__t__ = (void *)contr_appr__m__innerr__m__k(vr__t__,kr__ex__);
pc = &valuer__m__ofr__m__cps;
break; }
case _emptyr__m__k_cont: {
void *jumpout = _c->u._emptyr__m__k._jumpout;
_trstr *trstr = (_trstr *)jumpout;
longjmp(*trstr->jmpbuf, 1);
break; }
}
}

int mount_tram ()
{
srand (time (NULL));
jmp_buf jb;
_trstr trstr;
void *dismount;
int _status = setjmp(jb);
trstr.jmpbuf = &jb;
dismount = &trstr;
if(!_status) {
vockr__t__= (void *)contr_emptyr__m__k(dismount);
for(;;) {
pc();
}
}
return 0;
}
