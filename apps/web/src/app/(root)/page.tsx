import { Home } from "@/components/Home";
import { defaultLocale } from "@/i18n/config";

export default function RootHome() {
  return <Home locale={defaultLocale} />;
}
