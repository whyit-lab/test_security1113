package com.kt.arcus.common.interceptor;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.regex.Pattern;

import javax.servlet.ReadListener;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import org.apache.commons.io.IOUtils;

public class RequestWrapper extends HttpServletRequestWrapper {
	private byte[] b;

	private static final int MAX_REGEX_INPUT_LENGTH = 4096;

	private static final Pattern scriptPattern = Pattern.compile("(?is)<script\\b[^>]*+>(?:(?!</script).)*</script\\s*>");
	private static final Pattern srcPatternSingleQuote = Pattern.compile("(?i)\\bsrc\\s*=\\s*'[^']*+'");
	private static final Pattern srcPatternDoubleQuote = Pattern.compile("(?i)\\bsrc\\s*=\\s*\"[^\"]*+\"");
	private static final Pattern evalPattern = Pattern.compile("(?i)\\beval\\s*\\([^)]*+\\)");
	private static final Pattern expPattern = Pattern.compile("(?i)\\bexpression\\s*\\([^)]*+\\)");
	private static final Pattern jsPattern1 = Pattern.compile("(?i)javascript:[^\\s\"')]*");
	private static final Pattern jsPatternGeneral = Pattern.compile("(?i)javascript:");
	private static final Pattern vbPattern = Pattern.compile("(?i)vbscript:");
	private static final Pattern onloadPattern = Pattern.compile("(?i)\\bonload\\s*=\\s*(\"[^\"]*\"|'[^']*'|[^\\s>]+)");
	private static final Pattern onpointerPattern = Pattern.compile("(?i)<[^>]*+\\bonpointer\\b[^>]*+>");
	private static final Pattern ontogglePattern = Pattern.compile("(?i)<[^>]*+\\bontoggle\\b[^>]*+>");
	private static final Pattern iframePattern = Pattern.compile("(?i)<iframe\\b[^>]*+>");

	private static final String[] filterStrings = {
		// "javascript",		// ignore simple patterns
		// "vbscript",
		// "expression",
		// "applet",
		// "meta",
		// "xml",
		// "blink",
		// "link",
		// "style",
		// "script",
		// "embed",
		// "object",
		// "iframe",
		// "frame",
		// "fr",
		// "ameset",
		// "ilayer",
		// "layer",
		// "bgsound",
		// "title",
		// "base",
		// "eval",
		// "innerHTML",
		// "charset",
		// "document",
		// "string",
		// "create",
		// "append",
		// "bin",
		// "ding",
		// "alert",
		// "msgbox",
		// "refresh",
		// "cookie",
		// "void",
		// "href",
		"onabort",				// filter event keywords
		"onactivae",
		"onafterprint",
		"onafterupdate",
		"onbefore",
		"onbeforeactivate",
		"onbeforecopy",
		"onbeforecut",
		"onbeforedeactivate",
		"onbeforeeditfocus",
		"onbeforepaste",
		"onbeforeprint",
		"onbeforeunload",
		"onbeforeupdate",
		"onblur",
		"onbounce",
		"oncellchange",
		"onchange",
		"onclick",
		"oncontextmenu",
		"oncontrolselect",
		"oncopy",
		"oncut",
		"ondataavailable",
		"ondatasetchanged",
		"ondatas",
		"etcomplete",
		"ondblclick",
		"ondeactivate",
		"ondrag",
		"ondragend",
		"ondragenter",
		"ondragleave",
		"ondragover",
		"ondragstart",
		"ondrop",
		"onerror",
		"onerrorupdate",
		"onfilterchange",
		"onfinish",
		"onfocus",
		"onfocusin",
		"onfocusout",
		"onhelp",
		"onkeydown",
		"onkeypress",
		"onkeyup",
		"onlayoutcomplete",
		"onload",
		"onlosecapture",
		"onmousedown",
		"onmouseenter",
		"onmouseleave",
		"onmousemove",
		"onmouseout",
		"onmouseover",
		"onmouseup",
		"onmousewheel",
		"onmove",
		"onmoveend",
		"onmovestart",
		"onpaste",
		"onpropertychange",
		"onreadystatechange",
		"onreset",
		"onresize",
		"onresizeend",
		"onresizestart",
		"onrowenter",
		"onrowexit",
		"onrowsdelete",
		"onrowsinserted",
		"onscroll",
		"onselect",
		"onselectionchange",
		"onselectstart",
		"onstart",
		"onstop",
		"onsubmit",
		"onunload"
	};

	private String stripXSS(String value) {
		if (value == null) {
			return null;
		}

		String sanitized = value;
		if (sanitized.length() > MAX_REGEX_INPUT_LENGTH) {
			sanitized = escapeForLargeInput(sanitized);
		} else {
			sanitized = applyRegexSanitizers(sanitized);
		}

		for (String token : filterStrings) {
			sanitized = sanitized.replace(token, "_" + token + "_");
		}
		return sanitized;
	}

	private String applyRegexSanitizers(String value) {
		String sanitized = value;
		sanitized = scriptPattern.matcher(sanitized).replaceAll("");
		sanitized = srcPatternSingleQuote.matcher(sanitized).replaceAll("");
		sanitized = srcPatternDoubleQuote.matcher(sanitized).replaceAll("");
		sanitized = evalPattern.matcher(sanitized).replaceAll("");
		sanitized = expPattern.matcher(sanitized).replaceAll("");
		sanitized = jsPattern1.matcher(sanitized).replaceAll("");
		sanitized = jsPatternGeneral.matcher(sanitized).replaceAll("");
		sanitized = vbPattern.matcher(sanitized).replaceAll("");
		sanitized = onloadPattern.matcher(sanitized).replaceAll("");
		sanitized = onpointerPattern.matcher(sanitized).replaceAll("");
		sanitized = ontogglePattern.matcher(sanitized).replaceAll("");
		sanitized = iframePattern.matcher(sanitized).replaceAll("");
		return sanitized;
	}

	private String escapeForLargeInput(String value) {
		StringBuilder builder = new StringBuilder(value.length());
		for (int i = 0; i < value.length(); i++) {
			char ch = value.charAt(i);
			switch (ch) {
			case '<':
				builder.append("&lt;");
				break;
			case '>':
				builder.append("&gt;");
				break;
			case '"':
				builder.append("&quot;");
				break;
			case '\'':
				builder.append("&#39;");
				break;
			default:
				builder.append(ch);
				break;
			}
		}
		return builder.toString();
	}

	public RequestWrapper(HttpServletRequest request) throws IOException {
		super(request);
		// // XssFilter filter = XssFilter.getInstance("lucy-xss-superset.xml");
		// String body = getBody(request);
		// // String filtered = new String(filter.doFilter(body));
		// String filtered = stripXSS(body);
		// b = filtered.getBytes();
		// // b = new String(filter.doFilter(getBody(request))).getBytes();

 		b = new String(stripXSS(getBody(request))).getBytes();
	}

	public ServletInputStream getInputStream() throws IOException {
 		final ByteArrayInputStream bis = new ByteArrayInputStream(b);
 		return new ServletInputStreamImpl(bis);
 	}

 	class ServletInputStreamImpl extends ServletInputStream{
 		private InputStream is;

 		public ServletInputStreamImpl(InputStream bis){
 			is = bis;
 		}

 		public int read() throws IOException {
 			return is.read();
 		}

 		public int read(byte[] b) throws IOException {
 			return is.read(b);
 		}

		@Override
		public boolean isFinished() {
			return false;
		}

		@Override
		public boolean isReady() {
			return false;
		}

		@Override
		public void setReadListener(ReadListener readListener) {
		}
 	}

 	public static String getBody(HttpServletRequest request) throws IOException {
 	    String body = null;
 	    StringBuilder stringBuilder = new StringBuilder();
 	    BufferedReader bufferedReader = null;

 	    try {
 	        InputStream inputStream = request.getInputStream();
 	        if (inputStream != null) {
 	            bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
 	            char[] charBuffer = new char[128];
 	            int bytesRead = -1;
 	            while ((bytesRead = bufferedReader.read(charBuffer)) > 0) {
 	                stringBuilder.append(charBuffer, 0, bytesRead);
 	            }
 	        } else {
 	            stringBuilder.append("");
 	        }
 	    } catch (IOException ex) {
 	        throw ex;
 	    } finally {
 	        if (bufferedReader != null) {
 	            try {
 	                bufferedReader.close();
 	            } catch (IOException ex) {
 	                throw ex;
 	            }
 	        }
 	    }

 	    body = stringBuilder.toString();
 	    return body;
 	}
}