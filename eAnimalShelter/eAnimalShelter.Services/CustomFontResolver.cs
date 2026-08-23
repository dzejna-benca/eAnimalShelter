using System.Reflection;
using PdfSharpCore.Fonts;

public class CustomFontResolver : IFontResolver
{
    public string DefaultFontName => "DejaVu Sans";

    public byte[] GetFont(
        string faceName)
    {
        var assembly = Assembly.GetExecutingAssembly();

        using var stream = assembly.GetManifestResourceStream(
            "eAnimalShelter.Services.Fonts.DejaVuSans.ttf"
        );

        using var ms = new MemoryStream();

        stream.CopyTo(ms);

        return ms.ToArray();
    }

    public FontResolverInfo ResolveTypeface(
        string familyName,
        bool isBold,
        bool isItalic)
    {
        return new FontResolverInfo(
            "DejaVu Sans"
        );
    }
}