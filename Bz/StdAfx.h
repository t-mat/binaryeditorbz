// stdafx.h : include file for standard system include files,
//	or project specific include files that are used frequently, but
//		are changed infrequently
//
#define FILE_MAPPING

#define VC_EXTRALEAN		// Windows �w�b�_�[����g�p����Ă��Ȃ����������O���܂��B
#define WINVER 0x0501 //XP
#define _WIN32_WINNT 0x0501 //XP
#define _WIN32_WINDOWS 0x0410 // ����� Windows Me �܂��͂���ȍ~�̃o�[�W���������ɓK�؂Ȓl�ɕύX���Ă��������B
#define _WIN32_IE 0x0600	// ����� IE �̑��̃o�[�W���������ɓK�؂Ȓl�ɕύX���Ă��������B

#define ISOLATION_AWARE_ENABLED 1

#include <stdio.h>
#include <windows.h>

#ifdef _DEBUG
#include "vld.h" // https://vld.codeplex.com/
#endif

#define _WTL_NO_AUTOMATIC_NAMESPACE

#include <atlbase.h>
#include <atlstr.h>
#include <atlapp.h>

extern WTL::CAppModule _Module;

#include <atlcoll.h>

//#define _WTL_NO_AUTOMATIC_NAMESPACE
#include <atlapp.h>
#include <atldlgs.h>
#include <atlgdi.h>//CDCHandle
#include <atlctrls.h>//CComboBox
#include <atlctrlx.h>
#include <atlframe.h>//COwnerDraw
#include <atlcrack.h>
#include <atlmisc.h>
#include <atlddx.h>
#include <atlsplit.h>
#include <atlfile.h>
#include <atlutil.h>
#include <atlscrl.h>
#include <atlprint.h>

#if defined(_WTL_VER) && ((_WTL_VER) >= 0x1000)
// Since WTL::CPoint, WTL::CRect and WTL::CSize are removed from WTL10,
// we must add them.  See also "Announcing start of WTL10"
// https://sourceforge.net/p/wtl/discussion/374433/thread/e92e8fe6/?limit=25
namespace WTL {
    typedef ::CPoint CPoint;    // atltypes.h : CPoint
    typedef ::CRect CRect;      // atltypes.h : CPoint
    typedef ::CSize CSize;      // atltypes.h : CPoint
}
#endif

#include "TreeListView.h"

#include <shlobj.h>

#include "afxres.h"
#include "resource.h"
#include "..\cmos.h"

#include <imagehlp.h>

//#include "MemDC.h"

#include "Bz.h"
#include "BZDpi.h"

//#define SFC_EASYDEBUG
#include "SuperFileCon.h"

#include "BZSubView.h"

#include "tamascrlu64v.h"
#include "tamasplit.h"
#include "BZCoreData.h"

#include "BZOption.h"
extern CBZOptions options;

/*
#ifdef _UNICODE
#if defined _M_IX86
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='x86' publicKeyToken='6595b64144ccf1df' language='*'\"")
#elif defined _M_IA64
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='ia64' publicKeyToken='6595b64144ccf1df' language='*'\"")
#elif defined _M_X64
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='amd64' publicKeyToken='6595b64144ccf1df' language='*'\"")
#else
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='*' publicKeyToken='6595b64144ccf1df' language='*'\"")
#endif
#endif
*/
