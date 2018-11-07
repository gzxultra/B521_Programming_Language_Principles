void *expr__t__, *vocenvr__t__, *aeenvr__t__, *ackr__t__, *aekr__t__, *akkr__t__, *vockr__t__, *vr__t__, *addrr__t__, *closr__t__, *xr__t__;

void (*pc)();

struct expr;
typedef struct expr expr;
struct expr {
  enum {
    _const_expr,
    _var_expr,
    _if_expr,
    _mult_expr,
    _subr1_expr,
    _zero_expr,
    _letcc_expr,
    _throw_expr,
    _let_expr,
    _lambda_expr,
    _app_expr
  } tag;
  union {
    struct { void *_cexp; } _const;
    struct { void *_n; } _var;
    struct { void *_test; void *_conseq; void *_alt; } _if;
    struct { void *_nexpr1; void *_nexpr2; } _mult;
    struct { void *_nexp; } _subr1;
    struct { void *_nexp; } _zero;
    struct { void *_body; } _letcc;
    struct { void *_kexp; void *_vexp; } _throw;
    struct { void *_exp; void *_body; } _let;
    struct { void *_body; } _lambda;
    struct { void *_rator; void *_rand; } _app;
  } u;
};

void *exprr_const(void *cexp);
void *exprr_var(void *n);
void *exprr_if(void *test, void *conseq, void *alt);
void *exprr_mult(void *nexpr1, void *nexpr2);
void *exprr_subr1(void *nexp);
void *exprr_zero(void *nexp);
void *exprr_letcc(void *body);
void *exprr_throw(void *kexp, void *vexp);
void *exprr_let(void *exp, void *body);
void *exprr_lambda(void *body);
void *exprr_app(void *rator, void *rand);

struct cont;
typedef struct cont cont;
struct cont {
  enum {
    _multr__m__innerr__m__k_cont,
    _multr__m__outerr__m__k_cont,
    _subr__m__k_cont,
    _zeror__m__k_cont,
    _ifr__m__k_cont,
    _throwr__m__k_cont,
    _letr__m__k_cont,
    _appr__m__innerr__m__k_cont,
    _appr__m__outerr__m__k_cont,
    _emptyr__m__k_cont
  } tag;
  union {
    struct { void *_rr1r__ex__; void *_kr__ex__; } _multr__m__innerr__m__k;
    struct { void *_xr2r__ex__; void *_envr__ex__; void *_kr__ex__; } _multr__m__outerr__m__k;
    struct { void *_kr__ex__; } _subr__m__k;
    struct { void *_kr__ex__; } _zeror__m__k;
    struct { void *_conseqr__ex__; void *_altr__ex__; void *_envr__ex__; void *_kr__ex__; } _ifr__m__k;
    struct { void *_vr__m__expr__ex__; void *_envr__ex__; } _throwr__m__k;
    struct { void *_bodyr__ex__; void *_envr__ex__; void *_kr__ex__; } _letr__m__k;
    struct { void *_ratorr__ex__; void *_kr__ex__; } _appr__m__innerr__m__k;
    struct { void *_randr__ex__; void *_envr__ex__; void *_kr__ex__; } _appr__m__outerr__m__k;
    struct { void *_jumpout; } _emptyr__m__k;
  } u;
};

void *contr_multr__m__innerr__m__k(void *rr1r__ex__, void *kr__ex__);
void *contr_multr__m__outerr__m__k(void *xr2r__ex__, void *envr__ex__, void *kr__ex__);
void *contr_subr__m__k(void *kr__ex__);
void *contr_zeror__m__k(void *kr__ex__);
void *contr_ifr__m__k(void *conseqr__ex__, void *altr__ex__, void *envr__ex__, void *kr__ex__);
void *contr_throwr__m__k(void *vr__m__expr__ex__, void *envr__ex__);
void *contr_letr__m__k(void *bodyr__ex__, void *envr__ex__, void *kr__ex__);
void *contr_appr__m__innerr__m__k(void *ratorr__ex__, void *kr__ex__);
void *contr_appr__m__outerr__m__k(void *randr__ex__, void *envr__ex__, void *kr__ex__);
void *contr_emptyr__m__k(void *jumpout);

void applyr__m__k();
void valuer__m__ofr__m__cps();
struct envr_;
typedef struct envr_ envr_;
struct envr_ {
  enum {
    _emptyr__m__env_envr_,
    _newenv_envr_
  } tag;
  union {
    struct { char dummy; } _emptyr__m__env;
    struct { void *_envr__ex__; void *_objr__ex__; } _newenv;
  } u;
};

void *envr_r_emptyr__m__env();
void *envr_r_newenv(void *envr__ex__, void *objr__ex__);

void applyr__m__env();
struct closure;
typedef struct closure closure;
struct closure {
  enum {
    _clos_closure
  } tag;
  union {
    struct { void *_body; void *_env; } _clos;
  } u;
};

void *closurer_clos(void *body, void *env);

void applyr__m__closure();
int main();
int mount_tram();

struct _trstr;
typedef struct _trstr _trstr;
struct _trstr {
  jmp_buf *jmpbuf;
  int value;
};

