import { Navbar, NavbarBrand, NavbarContent, NavbarItem, Link, Button, Spacer } from "@nextui-org/react";
import { AcmeLogo } from "../../public/LuckyChainLogo.jsx";
import TabsDemo from "../../components/TabsDemo"
export default function Home() {
  return (
    <main className="">
      <div className="w-full h-[100vh]">
        <div className="absolute top-[20%] left-1/2 transform -translate-x-1/2 z-40">
          <TabsDemo />
        </div>
        <iframe className="w-full h-full" src="/index.html">
        </iframe>
      </div>
    </main>
  );
}
