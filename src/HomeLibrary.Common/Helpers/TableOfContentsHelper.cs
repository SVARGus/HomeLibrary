using System.Net;
using System.Text;
using System.Xml.Linq;

namespace HomeLibrary.Common.Helpers
{
    /// <summary>
    /// Преобразует XML-оглавление книги в HTML для отображения на странице.
    /// </summary>
    public static class TableOfContentsHelper
    {
        /// <summary>
        /// Конвертирует XML-оглавление в HTML-список.
        /// Если строка не является валидным XML — возвращает её как есть (для обратной совместимости с HTML).
        /// </summary>
        public static string ToHtml(string xml)
        {
            if (string.IsNullOrWhiteSpace(xml))
                return string.Empty;

            XDocument doc;
            try
            {
                doc = XDocument.Parse(xml);
            }
            catch
            {
                // Не XML (возможно, уже HTML от TinyMCE) — вернуть как есть
                return xml;
            }

            var root = doc.Root;
            if (root == null || root.Name.LocalName != "TableOfContents")
                return xml;

            var sb = new StringBuilder();
            sb.AppendLine("<ol class=\"list-group list-group-numbered mb-0\">");

            foreach (var chapter in root.Elements("Chapter"))
            {
                var chNumber = WebUtility.HtmlEncode(chapter.Attribute("Number")?.Value);
                var chTitle = WebUtility.HtmlEncode(chapter.Attribute("Title")?.Value);

                sb.AppendLine("  <li class=\"list-group-item\">");
                sb.AppendLine($"    <strong>Глава {chNumber}. {chTitle}</strong>");

                var sections = chapter.Elements("Section");
                bool hasSections = false;

                foreach (var section in sections)
                {
                    if (!hasSections)
                    {
                        sb.AppendLine("    <ul class=\"list-unstyled ms-3 mt-1 mb-0\">");
                        hasSections = true;
                    }

                    var secNumber = WebUtility.HtmlEncode(section.Attribute("Number")?.Value);
                    var secTitle = WebUtility.HtmlEncode(section.Attribute("Title")?.Value);
                    var secPage = WebUtility.HtmlEncode(section.Attribute("Page")?.Value);

                    var pageInfo = !string.IsNullOrEmpty(secPage)
                        ? $" <span class=\"text-muted\">— стр. {secPage}</span>"
                        : string.Empty;

                    sb.AppendLine($"      <li>{secNumber} {secTitle}{pageInfo}</li>");
                }

                if (hasSections)
                    sb.AppendLine("    </ul>");

                sb.AppendLine("  </li>");
            }

            sb.AppendLine("</ol>");
            return sb.ToString();
        }
    }
}
