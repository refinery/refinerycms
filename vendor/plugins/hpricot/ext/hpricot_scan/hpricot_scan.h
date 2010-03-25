/*
 * hpricot_scan.h
 *
 * $Author: why $
 * $Date: 2006-05-08 22:03:50 -0600 (Mon, 08 May 2006) $
 *
 * Copyright (C) 2006 why the lucky stiff
 * You can redistribute it and/or modify it under the same terms as Ruby.
 */

#ifndef hpricot_scan_h
#define hpricot_scan_h

#include <sys/types.h>

#if defined(_WIN32)
#include <stddef.h>
#endif

/*
 * Memory Allocation
 */
#if defined(HAVE_ALLOCA_H) && !defined(__GNUC__)
#include <alloca.h>
#endif

#ifndef NULL
# define NULL (void *)0
#endif

#define BUFSIZE 16384

#define S_ALLOC_N(type,n) (type*)malloc(sizeof(type)*(n))
#define S_ALLOC(type) (type*)malloc(sizeof(type))
#define S_REALLOC_N(var,type,n) (var)=(type*)realloc((char*)(var),sizeof(type)*(n))
#define S_FREE(n) free(n); n = NULL;

#define S_ALLOCA_N(type,n) (type*)alloca(sizeof(type)*(n))

#define S_MEMZERO(p,type,n) memset((p), 0, sizeof(type)*(n))
#define S_MEMCPY(p1,p2,type,n) memcpy((p1), (p2), sizeof(type)*(n))
#define S_MEMMOVE(p1,p2,type,n) memmove((p1), (p2), sizeof(type)*(n))
#define S_MEMCMP(p1,p2,type,n) memcmp((p1), (p2), sizeof(type)*(n))

typedef struct {
  void *name;
  void *attributes;
} hpricot_element;

typedef void (*hpricot_element_cb)(void *data, hpricot_element *token);

typedef struct hpricot_scan {
  int lineno;
  int cs;
  size_t nread;
  size_t mark;

  void *data;

  hpricot_element_cb xmldecl;
  hpricot_element_cb doctype;
  hpricot_element_cb xmlprocins;
  hpricot_element_cb starttag;
  hpricot_element_cb endtag;
  hpricot_element_cb emptytag;
  hpricot_element_cb comment;
  hpricot_element_cb cdata;

} http_scan;

// int hpricot_scan_init(hpricot_scan *scan);
// int hpricot_scan_finish(hpricot_scan *scan);
// size_t hpricot_scan_execute(hpricot_scan *scan, const char *data, size_t len, size_t off);
// int hpricot_scan_has_error(hpricot_scan *scan);
// int hpricot_scan_is_finished(hpricot_scan *scan);
// 
// #define hpricot_scan_nread(scan) (scan)->nread 

#endif
