import { notFound } from "next/navigation";
import { Home } from "@/components/Home";
import { isLocale } from "@/i18n/config";

export default async function LocaleHome({ params }: { params: Promise<{ lang: string }> }) {
  const { lang } = await params;
  if (!isLocale(lang)) notFound();
  return <Home locale={lang} />;
}
